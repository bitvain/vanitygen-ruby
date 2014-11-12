module Helpers
  def timeit
    s = Time.now
    yield
    Time.now - s
  end
end

RSpec.configure do |c|
  c.include Helpers
end
