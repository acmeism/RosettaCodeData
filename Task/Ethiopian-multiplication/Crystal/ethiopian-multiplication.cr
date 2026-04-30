def halve (n)  n // 2 end
def double (n) n * 2  end
def even? (n) n.even? end

def ethiopian_mult (l, r)
  product = 0
  while l >= 1
    unless even? l
      product += r
    end
    l = halve l
    r = double r
  end
  product
end

print "17 eth* 34 = ", ethiopian_mult(17, 34), "\n"
