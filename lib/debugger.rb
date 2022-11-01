# frozen_string_literal: true

# just a simple logger that only logs when an env var is set
class Debugger
  def self.log *args
    return unless ENV[ 'DEBUG' ]

    puts args
  end
end
