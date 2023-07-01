require 'forwardable'

class Stack
  extend Forwardable

  def initialize
    @stack = []
  end

  def_delegators :@stack, :push, :pop, :empty?
end
