# Generate a continued fraction from a rational number

def r2cf(n1,n2)
  while n2 > 0
    n1, (t1, n2) = n2, n1.divmod(n2)
    yield t1
  end
end
