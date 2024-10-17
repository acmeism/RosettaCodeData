def hailstone(n)
    seq = [n]
    until n == 1
        n = n.even? ? n // 2 : n * 3 + 1
        seq << n
    end
    seq
end

max_len = (1...100_000).max_by{|n| hailstone(n).size }
max = hailstone(max_len)
puts ([max_len, max.size, max.max, max.first(4), max.last(4)])
# => [77031, 351, 21933016, [77031, 231094, 115547, 346642], [8, 4, 2, 1]]

twenty_seven = hailstone(27)
puts ([twenty_seven.size, twenty_seven.first(4), max.last(4)])
# => [112, [27, 82, 41, 124], [8, 4, 2, 1]]
