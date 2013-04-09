require 'forwardable'

class Delegator; extend Forwardable
  attr_accessor :delegate
  def_delegator :@delegate, :thing, :delegated

  def initialize
    @delegate = Delegate.new()
  end
end

class Delegate
  def thing
    'Delegate'
  end
end

a = Delegator.new
puts a.delegated # prints "Delegate"
