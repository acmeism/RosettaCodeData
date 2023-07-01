class PCG32
  MASK64 = (1 << 64) - 1
  MASK32 = (1 << 32) - 1
  CONST  = 6364136223846793005

  def seed(seed_state, seed_sequence)
    @state = 0
    @inc = ((seed_sequence << 1) | 1) & MASK64
    next_int
    @state = @state + seed_state
    next_int
  end

  def next_int
    old = @state
    @state = ((old * CONST) + @inc) & MASK64
    xorshifted = (((old >> 18) ^ old) >> 27) & MASK32
    rot = (old >> 59) & MASK32
    answer = (xorshifted >> rot) | (xorshifted << ((-rot) & 31))
    answer & MASK32
  end

  def next_float
    next_int.fdiv(1 << 32)
  end

end

random_gen = PCG32.new
random_gen.seed(42, 54)
5.times{puts random_gen.next_int}

random_gen.seed(987654321, 1)
p 100_000.times.each{(random_gen.next_float * 5).floor}.tally.sort.to_h
