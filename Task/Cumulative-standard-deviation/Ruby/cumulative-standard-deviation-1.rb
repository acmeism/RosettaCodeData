class StdDevAccumulator
  def initialize
    @n, @sum, @sumofsquares = 0, 0.0, 0.0
  end

  def <<(num)
    # return self to make this possible:  sd << 1 << 2 << 3 # => 0.816496580927726
    @n += 1
    @sum += num
    @sumofsquares += num**2
    self
  end

  def stddev
    Math.sqrt( (@sumofsquares / @n) - (@sum / @n)**2 )
  end

  def to_s
    stddev.to_s
  end
end

sd = StdDevAccumulator.new
i = 0
[2,4,4,4,5,5,7,9].each {|n| puts "adding #{n}: stddev of #{i+=1} samples is #{sd << n}" }
