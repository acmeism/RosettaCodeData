def roots_of_unity(n)
  (0...n).map {|k| Complex.polar(1, 2 * Math::PI * k / n)}
end

p roots_of_unity(3)
