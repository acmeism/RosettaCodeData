def even(x);   x.even?; end
def halve(x);  x/2; end
def double(x); x*2; end

# iterative
def ethopian_multiply(a, b)
  product = 0
  while a >= 1
    p [a, b, even(a) ? "STRIKE" : "KEEP"] if $DEBUG
    product += b if not even(a)
    a = halve(a)
    b = double(b)
  end
  product
end

# recursive
def rec_ethopian_multiply(a, b)
  return 0 if a < 1
  p [a, b, even(a) ? "STRIKE" : "KEEP"] if $DEBUG
  (even(a) ? 0 : b) + rec_ethopian_multiply(halve(a), double(b))
end

$DEBUG = true   # $DEBUG also set to true if "-d" option given
a, b = 20, 5
puts "#{a} * #{b} = #{ethopian_multiply(a,b)}"; puts
