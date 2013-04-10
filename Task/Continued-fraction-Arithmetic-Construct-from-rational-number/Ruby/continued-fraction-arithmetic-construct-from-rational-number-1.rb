=begin
  Generate a continued fraction from a rational number

  Nigel Galloway, February 4th., 2013
=end
def r2cf(n1,n2)
  while n2 > 0
    t1 = n1/n2; t2 = n2; n2 = n1 - t1 * n2; n1 = t2; yield t1
  end
end
