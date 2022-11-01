# frozen_string_literal: true

# Class to hold a given chord
#
# TODO:
# - it would be nice for this class to provide a valid? method
#   rather than having to generate all chords and use comparisson
#   to match them
#
class Chord
  OCTAVE_LENGTH_IN_KEYS = 12

  attr_reader :keys

  class << self
    # finds a chord by an array of keys
    def find_by_keys keys
      chord = Chord.new keys.sort
      Chord.all.find { |c| c == chord }
    end

    # all chords (including 1st and 2nd inversions)
    def all
      @all ||= majors + minors + augs + dims
    end

    # major chords (including 1st and 2nd inversions)
    def majors
      @majors ||= OCTAVE_LENGTH_IN_KEYS.times.flat_map do |key|
        chord = Chord.major_for( key )
        inversions = [ chord.inverse( 1 ), chord.inverse( 2 ) ]
        [ chord ] + inversions
      end
    end

    # minor chords (including 1st and 2nd inversions)
    def minors
      @minors ||= OCTAVE_LENGTH_IN_KEYS.times.flat_map do |key|
        chord = Chord.minor_for( key )
        inversions = [ chord.inverse( 1 ), chord.inverse( 2 ) ]
        [ chord ] + inversions
      end
    end

    # augmented chords (including 1st and 2nd inversions)
    def augs
      @augs ||= OCTAVE_LENGTH_IN_KEYS.times.flat_map do |key|
        chord = Chord.augmented_for( key )
        inversions = [ chord.inverse( 1 ), chord.inverse( 2 ) ]
        [ chord ] + inversions
      end
    end

    # diminished chords (including 1st and 2nd inversions)
    def dims
      @dims ||= OCTAVE_LENGTH_IN_KEYS.times.flat_map do |key|
        chord = Chord.diminished_for( key )
        inversions = [ chord.inverse( 1 ), chord.inverse( 2 ) ]
        [ chord ] + inversions
      end
    end

    # builds a major chord based on a key
    def major_for base_key
      new [ base_key, base_key + 4, base_key + 7 ]
    end

    # builds a minor chord based on a key
    def minor_for base_key
      new [ base_key, base_key + 3, base_key + 7 ]
    end

    # builds an augmented chord based on a key
    def augmented_for base_key
      new [ base_key, base_key + 4, base_key + 8 ]
    end

    # builds a diminished chord based on a key
    def diminished_for base_key
      new [ base_key, base_key + 3, base_key + 6 ]
    end
  end

  def initialize keys
    @keys = keys.dup
  end

  # returns the alteration (major, minor, augmented, diminished)
  def alteration
    pure_chord = keys.rotate( keys.index( base_key )) # make sure chord starts in base key
    pure_chord = pure_chord.map { |k| k - pure_chord[ 0 ] } # offset elements based on base key

    case pure_chord
    when [ 0, 3, 7 ]
      'm'
    when [ 0, 4, 8 ]
      'aug'
    when [ 0, 3, 6 ]
      'dim'
    else
      '' # major
    end
  end

  # chord's base key
  def base_key
    @base_key ||= keys.min
  end

  # returns a new chord in the given inversion
  def inverse inversion
    self.class.new keys.rotate( inversion )
  end

  # returns the number of inversion (0, 1, 2)
  def inversion
    # TODO: there has to be a way of doing this by looking at the index of base_key in keys
    if keys[ 0 ] == base_key
      0
    elsif keys[ 1 ] == base_key
      2
    else
      1
    end
  end

  # names the chord
  def name
    @name ||=
      begin
        first_key = keys.first

        if inversion.zero?
          "#{ base_key.to_american }#{ alteration }"
        else
          "#{ base_key.to_american }#{ alteration }/#{ first_key.to_american }"
        end
      end
  end

  # keys, but transposed to the first octave
  def pure_keys
    @pure_keys ||= keys.map( &:to_first_octave )
  end

  def == other
    pure_keys == other.pure_keys
  end
end
