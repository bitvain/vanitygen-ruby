module Vanitygen
  autoload :VERSION, 'vanitygen/version'
  autoload :Ext,    'vanitygen/vanitygen_ext'

  def self.generate(pattern, options={})
    if pattern.is_a?(Regexp)
      options[:regex] = true
      Ext.generate([pattern.source], options)
    else
      Ext.generate([pattern.to_s], options)
    end
  end

  def self.continuous(patterns, options={})
    raise LocalJumpError.new('no block given') unless block_given?

    iters = options.delete(:iters) || Float::INFINITY

    if patterns.any? { |p| p.is_a?(Regexp) }
      if patterns.all? { |p| p.is_a?(Regexp) }
        patterns = patterns.map(&:source)
        options[:regex] = true
      else
        raise TypeError.new('patterns cannot be mixed regex and non-regex')
      end
    end
    while (iters -= 1) >= 0
      yield Ext.generate(patterns, options)
    end
  end

  def self.difficulty(pattern)
    return Ext.difficulty_prefix(pattern)
  end
end
