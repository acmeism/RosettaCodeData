module Mean
  def self.arithmetic (seq)
    seq.sum / seq.size
  end

  def self.geometric (seq)
    seq.product ** (1/seq.size)
  end

  def self.harmonic (seq)
    seq.size / seq.sum {|x| 1/x }
  end
end

seq = (1..10)

a = Mean.arithmetic(seq)
g = Mean.geometric(seq)
h = Mean.harmonic(seq)

puts "A = #{a}"
puts "G = #{g}"
puts "H = #{h}"
puts "A >= G >= H = #{a >= g >= h}"
