class Xorshift_star
  MASK64 = (1 << 64) - 1
  MASK32 = (1 << 32) - 1

  def initialize(seed = 0) = @state = seed & MASK64

  def next_int
    x = @state
    x =  x ^ (x >> 12)
    x = (x ^ (x << 25)) & MASK64
    x =  x ^ (x >> 27)
    @state = x
    (((x * 0x2545F4914F6CDD1D) & MASK64) >> 32) & MASK32
  end

  def next_float = next_int.fdiv((1 << 32))

end

random_gen =  Xorshift_star.new(1234567)
5.times{ puts random_gen.next_int}

random_gen = Xorshift_star.new(987654321)
tally      = Hash.new(0)
100_000.times{ tally[(random_gen.next_float*5).floor] += 1 }
puts tally.sort.map{|ar| ar.join(": ") }
