for candidate in 2 .. 2**19
  sum = Rational(1, candidate)
  for factor in 2 .. Integer.sqrt(candidate)
    if candidate % factor == 0
      sum += Rational(1, factor) + Rational(1, candidate / factor)
    end
  end
  if sum.denominator == 1
    puts "Sum of recipr. factors of %d = %d exactly %s" %
           [candidate, sum.to_i, sum == 1 ? "perfect!" : ""]
  end
end
