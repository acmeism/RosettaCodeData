φ_convergence = Enumerator.produce(1.0r){|prev| 1 + 1/prev}
(_prev, c), i = φ_convergence.each_cons(2).with_index(1).detect{|(v1, v2), i| (v1-v2).abs <= 1E-5}

puts "Result after #{i} iterations: #{c.to_f}
Error is about #{c - (0.5 * (1 + (5.0**0.5)))}."
