module Vanitygen
  autoload :VERSION, 'vanitygen/version'
  autoload :Cext,    'vanitygen/vanitygen_cext'

  def self.generate(pattern, options={})
    Cext.generate_prefixes([pattern], options[:case_insensitive])
  end

  def self.continuous(patterns, options={})
    raise LocalJumpError.new('no block given') unless block_given?

    iters = options.delete(:iters) || Float::INFINITY

    patterns.push options unless options.empty?
    while (iters -= 1) >= 0
      yield Cext.generate_prefixes(patterns, options[:case_insensitive])
    end
  end

  def self.difficulty(pattern)
    return Cext.difficulty_prefix(pattern)
  end
end
