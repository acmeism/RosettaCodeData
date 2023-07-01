require 'openssl'

factorial_primes = Enumerator.new do |y|
  fact = 1
  (1..).each do |i|
    fact *= i
    y << [i, "- 1", fact - 1] if OpenSSL::BN.new(fact - 1).prime?
    y << [i, "+ 1", fact + 1] if OpenSSL::BN.new(fact + 1).prime?
  end
end

factorial_primes.first(30).each do |a|
  s = a.last.to_s
  if s.size > 40 then
    puts "%d! %s = " % a.first(2) + "#{s[0,20]}...#{s[-20,20]}"
  else
    puts "%d! %s = %d" % a
  end
end
