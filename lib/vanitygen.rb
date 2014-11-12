module Vanitygen
  autoload :VERSION, 'vanitygen/version'
  autoload :Ext,    'vanitygen/vanitygen_ext'

  def self.generate(pattern, options={})
    Ext.generate([pattern], options)
  end

  def self.continuous(patterns, options={})
    raise LocalJumpError.new('no block given') unless block_given?

    iters = options.delete(:iters) || Float::INFINITY

    patterns.push options unless options.empty?
    while (iters -= 1) >= 0
      yield Ext.generate(patterns, options)
    end
  end

  def self.difficulty(pattern)
    return Ext.difficulty_prefix(pattern)
  end
end
