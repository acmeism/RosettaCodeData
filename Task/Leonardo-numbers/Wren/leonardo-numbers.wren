var leonardo = Fn.new { |first, add, limit|
    var leo = List.filled(limit, 0)
    leo[0] = first[0]
    leo[1] = first[1]
    for (i in 2...limit) leo[i] = leo[i-1] + leo[i-2] + add
    return leo
}

System.print("The first 25 Leonardo numbers with L(0) = 1, L(1) = 1 and Add = 1 are:")
for (l in leonardo.call([1, 1], 1, 25)) System.write("%(l) ")

System.print("\n\nThe first 25 Leonardo numbers with L(0) = 0, L(1) = 1 and Add = 0 are:")
for (l in leonardo.call([0, 1], 0, 25)) System.write("%(l) ")
System.print()
