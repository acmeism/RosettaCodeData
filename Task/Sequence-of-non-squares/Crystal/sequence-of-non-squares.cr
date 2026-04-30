struct Int
  def square?
    (r = Math.isqrt(self)) * r == self
  end
end

def non_squares
  (1..).each.map {|n| n + (0.5 + Math.sqrt(n)).to_i }
end

print "First 22 values in the sequence: "
puts non_squares.first(22).to_a

print "Squares in the non-squares sequence (up to n < 1000000): "
puts non_squares.first(999_999).select(&.square?).to_a
