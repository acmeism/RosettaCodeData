def factors(n)
    factors = `factor #{n}`.split(' ')[1..-1].map(&:to_i)
    factors.group_by { _1 }.map { |prime, exp| [prime, exp.size] }             # Ruby 2.7 or later
    #factors.group_by { |prime| prime }.map { |prime, exp| [prime, exp.size] } # for all versions
end

def fermat(n); (1 << (1 << n)) | 1 end

puts "Value for each Fermat Number F0 .. F9."
(0..9).each { |n| puts "F#{n} = #{fermat(n)}" }
puts
puts "Factors for each Fermat Number F0 .. F8."
(0..8).each { |n| puts "F#{n} = #{factors fermat(n)}" }
