require 'prime'

TwinPrime = Struct.new(:pr_1, :pr_2, :sqrt, :sum) do
  def to_s = "#{pr_1} + #{pr_2} = #{sqrt}^2 = #{sum}"
end

twin_primes_square_sum = Enumerator.new do |y|
  primes = Prime.each(10_000_000).each_cons(2)
  loop do
    candidate = primes.next
    next unless candidate.last - candidate.first == 2
    sum = candidate.sum
    isqrt = Integer.sqrt(sum)
    y << TwinPrime.new(candidate[0], candidate[1], isqrt, sum) if isqrt*isqrt == sum
  end
end

twin_primes_square_sum.each{|tp| puts tp}
