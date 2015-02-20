def unique(array)
    pure = Array.new
    for i in array
        flag = false
        for j in pure
            flag = true if j==i
        end
        pure << i unless flag
    end
    return pure
end


unique ["hi","hey","hello","hi","hey","heyo"]   # => ["hi", "hey", "hello", "heyo"]
unique [1,2,3,4,1,2,3,5,1,2,3,4,5]              # => [1,2,3,4,5]
