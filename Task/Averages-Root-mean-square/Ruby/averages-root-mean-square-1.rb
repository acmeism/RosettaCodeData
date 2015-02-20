class Array
  def quadratic_mean
    Math.sqrt( self.inject(0.0) {|s, y| s + y*y} / self.length )
  end
end

class Range
  def quadratic_mean
    self.to_a.quadratic_mean
  end
end

(1..10).quadratic_mean  # => 6.2048368229954285
