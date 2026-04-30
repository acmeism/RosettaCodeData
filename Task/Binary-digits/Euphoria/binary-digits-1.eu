function toBinary(integer i)
    sequence s
    s = {}
    while i do
        s = prepend(s, '0'+and_bits(i,1))
        i = floor(i/2)
    end while
    return s
end function

puts(1, toBinary(5) & '\n')
puts(1, toBinary(50) & '\n')
puts(1, toBinary(9000) & '\n')
