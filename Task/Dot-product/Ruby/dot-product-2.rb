class Array
  def dot_product(other)
    raise "not the same size!" if self.length != other.length
    self.zip(other).inject(0) {|dp, (a, b)| dp += a*b}
  end
end

p [1, 3, -5].dot_product [4, -2, -1]   # => 3
