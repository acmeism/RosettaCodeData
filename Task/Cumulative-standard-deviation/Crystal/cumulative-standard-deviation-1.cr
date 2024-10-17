class StdDevAccumulator
  def initialize
    @n, @sum, @sum2 = 0, 0.0, 0.0
  end

  def <<(num)
    @n += 1
    @sum += num
    @sum2 += num**2
    Math.sqrt (@sum2 * @n - @sum**2) / @n**2
  end
end

sd = StdDevAccumulator.new
i = 0
[2,4,4,4,5,5,7,9].each { |n| puts "adding #{n}: stddev of #{i+=1} samples is #{sd << n}" }
