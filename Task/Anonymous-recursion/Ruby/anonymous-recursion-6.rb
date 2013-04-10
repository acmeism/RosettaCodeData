require 'continuation' unless defined? Continuation

module Kernel
  module_function

  def recur(*args, &block)
    cont = catch(:recur) { return block[*args] }
    cont[block]
  end

  def recurse(*args)
    block = callcc { |cont| throw(:recur, cont) }
    block[*args]
  end
end

def fib(n)
  raise RangeError, "fib of negative" if n < 0
  recur(n) { |m| m < 2 ? m : (recurse m - 1) + (recurse m - 2) }
end
