require "prime"

def mersenne_prime_pow?(p)
  # Lucas-Lehmer test; expects prime as argument
  return true  if p == 2
  m_p = ( 1 << p ) - 1
  s = 4
  (p-2).times{ s = (s**2 - 2) % m_p }
  s == 0
end

@perfect_numerator = Prime.each.lazy.select{|p| mersenne_prime_pow?(p)}.map{|p| 2**(p-1)*(2**p-1)}
@perfects = @perfect_numerator.take(1).to_a

def perfect?(num)
  @perfects << @perfect_numerator.next until @perfects.last >= num
  @perfects.include? num
end

# demo
p (1..10000).select{|num| perfect?(num)}
t1 = Time.now
p perfect?(13164036458569648337239753460458722910223472318386943117783728128)
p Time.now - t1
