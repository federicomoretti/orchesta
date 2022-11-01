# frozen_string_literal: true

# Override Integer to make it easier to work with keys
class Integer
  # Constants
  AMERICAN_KEYS = [ 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B' ].freeze
  OCTAVE_LENGTH_IN_KEYS = 12

  def same_note? key
    to_first_octave == key.to_first_octave
  end

  def to_american
    AMERICAN_KEYS[ to_first_octave ]
  end

  def to_first_octave
    self % OCTAVE_LENGTH_IN_KEYS
  end
end
