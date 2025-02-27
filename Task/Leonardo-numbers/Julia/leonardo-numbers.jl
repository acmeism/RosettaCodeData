function leonardo(first::Int, second::Int, add::Int, amount::Int)
    nums = [first, second]
    for i in 3:amount
        append!(nums, nums[i-1] + nums[i-2] + add)
    end
    return nums
end

println("First 25 Leonardo numbers with L1 = 1 L2 = 1 and add number = 1 :")
println(leonardo(1,1,1,25))
println("First 25 Leonardo numbers with L1 = 0 L2 = 1 and add number = 0 :")
println(leonardo(1,1,0,25))
