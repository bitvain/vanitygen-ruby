require "vanitygen/version"

module Vanitygen
  def self.generate(pattern)
    loop do
      key = Bitcoin::Key.generate
      return key if key.addr.start_with?(pattern)
    end
  end

  def self.continuous(pattern, options={})
    raise LocalJumpError.new('no block given') unless block_given?
    iters = options.fetch(:iters, Float::INFINITY)

    while (iters -= 1) >= 0 do
      yield generate(pattern)
    end
  end

  def self.difficulty(pattern)
    return pattern.size
  end
end
