# frozen_string_literal: true

require_relative 'base'

# picks a random chord and waits for it to be played
module Games
  class GuessTheChord < Base
    def play
      tries = 0
      random_chord = Chord.majors.sample
      print "#{ random_chord.name } - "

      run do |chord|
        if chord == random_chord
          puts "\r#{ random_chord.name } - Correct!".ljust( 80 ) # avoid previous content to show up if longer

          random_chord = Chord.majors.sample
          tries = 0
          print "#{ random_chord.name } - "
        else
          tries += 1
          print "\r#{ random_chord.name } - Incorrect, that's #{ chord.name }. Tries: #{ tries }"
        end
      end
    end
  end
end
