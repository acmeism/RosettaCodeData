require 'mathn'

def mersenne_factor(p)
  limit = Math.sqrt(2**p - 1)
  k = 1
  while (2*k*p - 1) < limit
    q = 2*k*p + 1
    if prime?(q) and (q % 8 == 1 or q % 8 == 7) and trial_factor(2,p,q)
      # q is a factor of 2**p-1
      return q
    end
    k += 1
  end
  nil
end

def prime?(value)
  return false if value < 2
  png = Prime.new
  for prime in png
    q,r = value.divmod prime
    return true if q < prime
    return false if r == 0
  end
end

def trial_factor(base, exp, mod)
  square = 1
  ("%b" % exp).each_char {|bit| square = square**2 * (bit == "1" ? base : 1) % mod}
  (square == 1)
end

def check_mersenne(p)
  print "M#{p} = 2**#{p}-1 is "
  f = mersenne_factor(p)
  if f.nil?
    puts "prime"
  else
    puts "composite with factor #{f}"
  end
end

png = Prime.new
for p in png
  check_mersenne p
  break if p == 53
end
p = 929
check_mersenne p
