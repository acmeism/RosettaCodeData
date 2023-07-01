class Array
  def dot_product(other)
    raise "not the same size!" if self.length != other.length
    zip(other).sum {|a, b| a*b}
  end
end

p [1, 3, -5].dot_product [4, -2, -1]   # => 3
