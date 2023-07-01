squares = Enumerator.new {|y| 1.step{|n| y << n*n} }

puts "Square cubes: %p
Square non-cubes: %p" % squares.take(33).partition{|sq| Math.cbrt(sq).to_i ** 3 == sq }
