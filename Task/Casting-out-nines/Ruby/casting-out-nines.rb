N = 2
base = 10
c1 = 0
c2 = 0

for k in 1 .. (base ** N) - 1
    c1 = c1 + 1
    if k % (base - 1) == (k * k) % (base - 1) then
        c2 = c2 + 1
        print "%d " % [k]
    end
end

puts
print "Trying %d numbers instead of %d numbers saves %f%%" % [c2, c1, 100.0 - 100.0 * c2 / c1]
