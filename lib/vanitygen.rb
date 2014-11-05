require "vanitygen/version"

module Vanitygen
  def self.generate(*patterns)
    raise ArgumentError.new('wrong number of arguments (0 for 1+)') unless patterns.size > 0

    loop do
      key = Bitcoin::Key.generate
      if patterns.any? { |pattern| key.addr.start_with?(pattern) }
        return { address: key.addr, private_key: key.priv }
      end
    end
  end

  def self.continuous(*patterns)
    raise LocalJumpError.new('no block given') unless block_given?

    options = patterns.last.is_a?(Hash) ? patterns.pop : {}
    iters = options.fetch(:iters, Float::INFINITY)

    while (iters -= 1) >= 0
      yield generate(*patterns)
    end
  end

  def self.difficulty(pattern)
    return pattern.size
  end
end
