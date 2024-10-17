n, mean, sd, tau = 1000, 1, 0.5, (2 * Math::PI)
array = Array.new(n) { mean + sd * Math.sqrt(-2 * Math.log(rand)) * Math.cos(tau * rand) }

mean = array.sum / array.size
standev = Math.sqrt( array.sum{ |x| (x - mean) ** 2 } / array.size )
puts "mean = #{mean}, standard deviation = #{standev}"
