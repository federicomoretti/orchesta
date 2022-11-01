# frozen_string_literal: true

module Games
  class Base
    attr_reader :keyboard

    def initialize keyboard
      @keyboard = keyboard
    end

    private

    def run( & )
      keyboard.listen( & )
    end
  end
end
