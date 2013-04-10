class Array
  def quadratic_mean
    Math.sqrt( self.inject(0) {|s, y| s += y*y}.to_f / self.length )
  end
end

class Range
  def quadratic_mean
    self.to_a.quadratic_mean
  end
end

(1..10).quadratic_mean  # => 6.20483682299543
