require "vanitygen/version"

module Vanitygen
  def self.generate(pattern)
    pattern
  end

  def self.continuous(pattern)
    raise unless block_given?

    Thread.new do
      loop { yield generate(pattern) }
    end
  end

  def self.difficulty(pattern)
    return pattern.size
  end
end
