module Vanitygen
  autoload :VERSION, 'vanitygen/version'
  autoload :Ext,    'vanitygen/vanitygen_ext'

  def self.generate(pattern, options={})
    if pattern.is_a?(Regexp)
      options[:regex] = true
      pattern = pattern.source
    else
      pattern = pattern.to_s
    end

    ret = nil
    Ext.generate([pattern], options) { |data| ret = data }
    ret
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
      ret = nil
      Ext.generate(patterns, options) { |data| ret = data }
      yield ret
    end
  end

  def self.difficulty(pattern)
    return Ext.difficulty_prefix(pattern)
  end

  VALIDITY = /^1[^0OIl]*$/
  def self.valid?(pattern)
    pattern.length < 19 && !!(VALIDITY =~ pattern)
  end
end
