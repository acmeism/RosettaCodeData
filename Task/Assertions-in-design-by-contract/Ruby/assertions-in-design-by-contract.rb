require 'contracts'
include Contracts

Contract Num => Num
def double(x)
  x * 2
end

puts double("oops")
