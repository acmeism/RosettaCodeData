def divisors(n : Int32) : Array(Int32)
  divs = [1]
  divs2 = [] of Int32

  i = 2
  while i * i < n
    if n % i == 0
      j = n // i
      divs << i
      divs2 << j if i != j
    end

    i += 1
  end

  i = divs.size - 1

  # TODO: Use reverse
  while i >= 0
    divs2 << divs[i]
    i -= 1
  end

  divs2
end

def abundant(n : Int32, divs : Array(Int32)) : Bool
  divs.sum > n
end

def semiperfect(n : Int32, divs : Array(Int32)) : Bool
  if divs.size > 0
    h = divs[0]
    t = divs[1..]

    return n < h ? semiperfect(n, t) : n == h || semiperfect(n - h, t) || semiperfect(n, t)
  end

  return false
end

def sieve(limit : Int32) : Array(Bool)
  # false denotes abundant and not semi-perfect.
  # Only interested in even numbers >= 2

  w = Array(Bool).new(limit, false) # An array filled with 'false'

  i = 2
  while i < limit
    if !w[i]
      divs = divisors i

      if !abundant(i, divs)
        w[i] = true
      elsif semiperfect(i, divs)
        j = i
        while j < limit
          w[j] = true
          j += i
        end
      end
    end

    i += 2
  end

  w
end

def main
  w = sieve 17000
  count = 0
  max = 25

  print "The first 25 weird numbers are: "

  n = 2
  while count < max
    if !w[n]
      print "#{n} "
      count += 1
    end

    n += 2
  end

  puts "\n"
end

require "benchmark"
puts Benchmark.measure { main }
