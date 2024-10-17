def roots_of_unity(n)
  (0...n).map { |k| Complex.new(Math.cos(2 * Math::PI * k / n), Math.sin(2 * Math::PI * k / n)) }
end
