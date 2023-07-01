class Splitmix64
  MASK64 = (1 << 64) - 1
  C1, C2, C3 = 0x9e3779b97f4a7c15, 0xbf58476d1ce4e5b9, 0x94d049bb133111eb

  def initialize(seed = 0) =  @state = seed & MASK64

  def rand_i
    z = @state = (@state + C1) & MASK64
    z = ((z ^ (z >> 30)) * C2) & MASK64
    z = ((z ^ (z >> 27)) * C3) & MASK64
    (z ^ (z >> 31)) & MASK64
  end

  def rand_f = rand_i.fdiv(1<<64)

end

rand_gen = Splitmix64.new(1234567)
5.times{ puts rand_gen.rand_i }

rand_gen = Splitmix64.new(987654321)
p 100_000.times.lazy.map{(rand_gen.rand_f * 5).floor}.tally.sort.to_h
