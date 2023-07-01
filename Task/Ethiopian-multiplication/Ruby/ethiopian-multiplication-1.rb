def halve(x) = x/2
def double(x) = x*2

# iterative
def ethiopian_multiply(a, b)
  product = 0
  while a >= 1
    p [a, b, a.even? ? "STRIKE" : "KEEP"] if $DEBUG
    product += b unless a.even?
    a = halve(a)
    b = double(b)
  end
  product
end

# recursive
def rec_ethiopian_multiply(a, b)
  return 0 if a < 1
  p [a, b, a.even? ? "STRIKE" : "KEEP"] if $DEBUG
  (a.even? ? 0 : b) + rec_ethiopian_multiply(halve(a), double(b))
end

$DEBUG = true   # $DEBUG also set to true if "-d" option given
a, b = 20, 5
puts "#{a} * #{b} = #{ethiopian_multiply(a,b)}"; puts
