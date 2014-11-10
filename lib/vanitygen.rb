require 'vanitygen/version'
require 'vanitygen/vanitygen_cext'

module Vanitygen
  def self.generate(*patterns)
    options = patterns.last.is_a?(Hash) ? patterns.pop : {}
    raise ArgumentError.new('wrong number of arguments (0 for 1+)') unless patterns.size > 0

    if options[:case_insensitive]
      patterns = patterns.map(&:downcase)
    end

    loop do
      key = Bitcoin::Key.generate
      test = options[:case_insensitive] ? key.addr.downcase : key.addr
      if patterns.any? { |pattern| test.start_with?(pattern) }
        return { address: key.addr, private_key: key.priv }
      end
    end
  end

  def self.continuous(patterns, options={})
    raise LocalJumpError.new('no block given') unless block_given?

    iters = options.delete(:iters) || Float::INFINITY

    patterns.push options unless options.empty?
    while (iters -= 1) >= 0
      yield generate(*patterns)
    end
  end

  def self.difficulty(pattern)
    return pattern.size
  end
end
