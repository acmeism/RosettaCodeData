require 'continuation' unless defined? Continuation

module Kernel
  module_function

  def function(&block)
    f = (proc do |*args|
           (class << args; self; end).class_eval do
             define_method(:callee) { f }
           end
           ret = nil
           cont = catch(:function) { ret = block.call(*args); nil }
           cont[args] if cont
           ret
         end)
  end

  def arguments
    callcc { |cont| throw(:function, cont) }
  end
end

def fib(n)
  raise RangeError, "fib of negative" if n < 0
  function { |m|
    if m < 2
      m
    else
      arguments.callee[m - 1] + arguments.callee[m - 2]
    end
  }[n]
end
