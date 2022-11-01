# frozen_string_literal: true

dir = File.dirname File.expand_path( __FILE__ )
$LOAD_PATH.unshift "#{ dir }/lib"

require 'chord'
require 'debugger'
require 'keyboard'
require 'games/guess_the_chord'
require 'games/name_current_chord'
require 'initializers/integer'

# Initialize keyboard
keyboard = Keyboard.new

# Start the game
Games::GuessTheChord.new( keyboard ).play
