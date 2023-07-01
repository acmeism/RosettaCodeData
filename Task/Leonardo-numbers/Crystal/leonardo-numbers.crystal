def leonardo(l_zero, l_one, add, amount)
    terms = [l_zero, l_one]
    while terms.size < amount
        new = terms[-1] + terms[-2]
        new += add
        terms << new
    end
    terms
end

puts "First 25 Leonardo numbers: \n#{ leonardo(1,1,1,25) }"
puts "Leonardo numbers with fibonacci parameters:\n#{ leonardo(0,1,0,25) }"
