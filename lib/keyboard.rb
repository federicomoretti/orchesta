# frozen_string_literal: true

require 'unimidi'
require 'set'
require 'debugger'

# represents a Yamaha p-121 keyboard
#
# REFERENCE
#
# Messages:
# 144: key on
# 128: key off
#
# Keys:
# 12 keys (7 white + 5 black), starting with C at 0
#
class Keyboard
  def initialize; end

  # listens to midi input and yields a chord when found
  def listen
    input = select_input
    pressed_keys = Set.new

    Thread.new do
      loop do
        m = input.gets # shape of m = [{ data: [ ... ], timestamp: ... }], N elements if N keys pressed at same time

        m.each do |message|
          data = message[ :data ]
          next if data.empty?

          case data[ 0 ]
          when 254 # not sure
            next
          when 144 # key down
            pressed_keys << data[ 1 ]
          when 128 # key up
            pressed_keys.delete data[ 1 ]
          end

          next if pressed_keys.length < 3 # minimum 3 keys to match chord

          chord = Chord.find_by_keys pressed_keys.to_a
          next unless chord # next unless chord is found

          log_debug pressed_keys, chord

          yield chord if block_given?
        end
      end
    end

    gets # stop on Enter
  end

  # opens up a new MIDI input
  def select_input
    # Prompt the user
    # input = UniMIDI::Input.gets

    # Auto-select first MIDI
    UniMIDI::Input.first.open
  end

  private

  def log_debug pressed_keys, chord
    Debugger.log '------------------------'
    Debugger.log 'Chord found!'
    Debugger.log "pressed keys: #{ pressed_keys.inspect }"
    Debugger.log "keys: #{ chord.keys.inspect }"
    Debugger.log "pure keys: #{ chord.pure_keys.inspect }"
    Debugger.log "base key: #{ chord.base_key } (#{ chord.base_key.to_american })"
    Debugger.log "inversion: #{ chord.inversion }"
  end
end
