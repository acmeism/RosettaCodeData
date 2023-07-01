# Constants
# First generator
A1 = [0, 1403580, -810728]
M1 = 2**32 - 209
# Second Generator
A2 = [527612, 0, -1370589]
M2 = 2**32 - 22853

D = M1 + 1

class MRG32k3a

  def seed(seed_state)
    raise ArgumentError unless seed_state.between?(0, D)
    @x1 = [seed_state, 0, 0]
    @x2 = [seed_state, 0, 0]
  end

  def next_int
    x1i = (A1[0]*@x1[0] + A1[1]*@x1[1] + A1[2]*@x1[2]).modulo M1
    x2i = (A2[0]*@x2[0] + A2[1]*@x2[1] + A2[2]*@x2[2]).modulo M2
    @x1 = [x1i, @x1[0], @x1[1]]   # Keep last three
    @x2 = [x2i, @x2[0], @x2[1]]   # Keep last three
    z   = (x1i - x2i) % M1
    return z + 1
  end

  def next_float
    next_int.to_f / D
  end

end

random_gen = MRG32k3a.new
random_gen.seed(1234567)
5.times{ puts random_gen.next_int}

random_gen = MRG32k3a.new
random_gen.seed(987654321)
p 100_000.times.map{(random_gen.next_float() * 5).floor}.tally.sort.to_h
