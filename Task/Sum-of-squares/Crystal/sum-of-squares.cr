def sum_squares(a)
    a.map{|e| e*e}.sum()
end

puts sum_squares([1, 2, 3])
# => 14
