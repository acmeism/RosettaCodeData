class Fixnum
  def **(m)
    print "Fixnum "
    pow(m)
  end
end
class Bignum
  def **(m)
    print "Bignum "
    pow(m)
  end
end
class Float
  def **(m)
    print "Float "
    pow(m)
  end
end

p i=2**64
p i ** 2
p 2.2 ** 3
