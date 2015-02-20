module Hailstone
  ListNode = Struct.new(:value, :size, :succ) do
    def each
      node = self
      while node
        yield node.value
        node = node.succ
      end
    end
  end

  @@sequence = {1 => ListNode[1,1]}

  module_function

  def sequence(n)
    unless @@sequence[n]
      m, ary = n, []
      until succ = @@sequence[m]
        ary << m
        m = m.even? ? (m / 2) : (3 * m + 1)
      end
      ary.reverse_each do |m|
        @@sequence[m] = succ = ListNode[m, succ.size + 1, succ]
      end
    end
    @@sequence[n]
  end
end

puts "for n = 27, show sequence length and first and last 4 elements"
hs27 = Hailstone.sequence(27).entries
p [hs27.size, hs27[0..3], hs27[-4..-1]]

# find the longest sequence among n less than 100,000
n = (1 ... 100_000).max_by{|n| Hailstone.sequence(n).size}
puts "#{n} has a hailstone sequence length of #{Hailstone.sequence(n).size}"
puts "the largest number in that sequence is #{Hailstone.sequence(n).max}"
