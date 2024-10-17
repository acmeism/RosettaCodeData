def cartesian_product(a, b)
    return a.flat_map { |i| b.map { |j| [i, j] } }
end


def cartesian_product(l)
    if l.size <= 1
        return l
    elsif l.size == 2
        return cartesian_product(l[0], l[1])
    end

    return l[0].flat_map { |i|
        cartesian_product(l[1..]).map { |j|
            [i, j].flatten
        }
    }
end


tests = [ [[1, 2], [3, 4]],
          [[3, 4], [1, 2]],
          [[1, 2], [] of Int32],
          [[] of Int32, [1, 2]],
          [[1, 2, 3], [30], [500, 100]],
          [[1, 2, 3], [] of Int32, [500, 100]],
          [[1776, 1789], [7, 12], [4, 14, 23], [0, 1]] ]

tests.each { |test|
    puts "#{test.join(" x ")} ->"
    puts "    #{cartesian_product(test)}"
    puts ""
}
