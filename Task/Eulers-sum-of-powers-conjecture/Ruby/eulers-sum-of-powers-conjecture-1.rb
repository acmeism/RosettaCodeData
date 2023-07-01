power5 = (1..250).each_with_object({}){|i,h| h[i**5]=i}
result = power5.keys.repeated_combination(4).select{|a| power5[a.inject(:+)]}
puts result.map{|a| a.map{|i| "#{power5[i]}**5"}.join(' + ') + " = #{power5[a.inject(:+)]}**5"}
