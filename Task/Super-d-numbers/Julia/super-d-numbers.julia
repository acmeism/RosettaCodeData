function superd(N)
    println("First 10 super-$N numbers:")
    count, j = 0, BigInt(3)
    target = Char('0' + N)^N
    while count < 10
        if occursin(target, string(j^N * N))
            count += 1
            print("$j ")
        end
        j += 1
    end
    println()
end

for n in 2:9
    @time superd(n)
end
