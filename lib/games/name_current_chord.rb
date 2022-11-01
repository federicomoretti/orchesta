# frozen_string_literal: true

require_relative 'base'

# names the chord being played
module Games
  class NameCurrentChord < Base
    def play
      run do |chord|
        text = "Chord: #{ chord.name }"

        inv = chord.inversion
        text += " (#{ chord.inversion } inv)" if inv.positive?

        puts text
      end
    end
  end
end
