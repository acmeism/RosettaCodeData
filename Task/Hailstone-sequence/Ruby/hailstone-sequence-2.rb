module Hailstone
  class ListNode
    include Enumerable
    attr_reader :value, :size, :succ

    def initialize(value, size, succ=nil)
      @value, @size, @succ = value, size, succ
    end

    def each
      node = self
      while node
	yield node.value
	node = node.succ
      end
    end
  end

  @@sequence = {1 => ListNode.new(1, 1)}

  module_function

  def sequence(n)
    unless @@sequence[n]
      ary = []
      m = n
      until succ = @@sequence[m]
        ary << m
        m = (m.even?) ? (m / 2) : (3 * m + 1)
      end
      ary.reverse_each do |m|
        @@sequence[m] = succ = ListNode.new(m, succ.size + 1, succ)
      end
    end
    @@sequence[n]
  end
end

# for n = 27, show sequence length and first and last 4 elements
hs27 = Hailstone.sequence(27).to_a
p [hs27.length, hs27[0..3], hs27[-4..-1]]

# find the longest sequence among n less than 100,000
hs_big = (1 ... 100_000) .collect {|n|
  Hailstone.sequence n}.max_by {|hs| hs.size}
puts "#{hs_big.first} has a hailstone sequence length of #{hs_big.size}"
puts "the largest number in that sequence is #{hs_big.max}"
