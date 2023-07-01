class Maybe
  def initialize(value)
    @value = value
  end

  def map
    if @value.nil?
      self
    else
      Maybe.new(yield @value)
    end
  end
end

Maybe.new(3).map { |n| 2*n }.map { |n| n+1 }
#=> #<Maybe @value=7>

Maybe.new(nil).map { |n| 2*n }.map { |n| n+1 }
#=> #<Maybe @value=nil>

Maybe.new(3).map { |n| nil }.map { |n| n+1 }
#=> #<Maybe @value=nil>

# alias Maybe#new and write bind to be in line with task

class Maybe
  class << self
    alias :unit :new
  end

  def initialize(value)
    @value = value
  end

  def bind
    if @value.nil?
      self
    else
      yield @value
    end
  end
end

Maybe.unit(3).bind { |n| Maybe.unit(2*n) }.bind { |n| Maybe.unit(n+1) }
#=> #<Maybe @value=7>

Maybe.unit(nil).bind { |n| Maybe.unit(2*n) }.bind { |n| Maybe.unit(n+1) }
#=> #<Maybe @value=nil>
