require "big"

def factors(n)
    factors = `factor #{n}`.split(' ')[1..-1].map(&.to_big_i)
    factors.group_by(&.itself).map { |prime, exp| [prime, exp.size] }
end

def fermat(n); (1.to_big_i << (1 << n)) | 1 end

puts "Value for each Fermat Number F0 .. F9."
(0..9).each { |n| puts "F#{n} = #{fermat(n)}" }
puts
puts "Factors for each Fermat Number F0 .. F8."
(0..8).each { |n| puts "F#{n} = #{factors fermat(n)}" }
