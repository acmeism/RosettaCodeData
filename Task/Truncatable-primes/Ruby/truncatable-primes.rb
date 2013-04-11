def left_truncatable?(n)
  return truncatable?(n, $left_truncate)
end

$left_truncate = proc do |n|
  begin
    n = Integer(String(n)[1..-1])
  rescue ArgumentError
    n = 0
  end
  n
end

def right_truncatable?(n)
  return truncatable?(n, $right_truncate)
end

$right_truncate = proc {|n| n/10}

def truncatable?(n, trunc_func)
  return false if String(n).include? "0"
  loop do
    n = trunc_func.call(n)
    return true if n == 0
    return false if not Prime.prime?(n)
  end
end

#############
require 'prime'
primes = Prime.each(1_000_000).to_a.reverse

p primes.detect {|p| left_truncatable? p}
p primes.detect {|p| right_truncatable? p}
