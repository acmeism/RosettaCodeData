function compare(a, b)
    println("\n$a is of type $(typeof(a)) and $b is of type $(typeof(b))")
    if a <  b println("$a is strictly less than $b") end
    if a <= b println("$a is less than or equal to $b") end
    if a >  b println("$a is strictly greater than $b") end
    if a >= b println("$a is greater than or equal to $b") end
    if a == b println("$a is equal to $b") end
    if a != b println("$a is not equal to $b") end
    if a === b println("$a has object identity with $b") end
    if a !== b println("$a has negated object identity with $b") end
end

compare("YUP", "YUP")
compare('a', 'z')
compare("24", "123")
compare(24, 123)
compare(5.0, 5)
