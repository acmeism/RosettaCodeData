using ResumableFunctions

@resumable function gen_inconsummate(maxwanted)
    mindigitsums = map(i -> (10^i, (10^(i-2) * 11 - 1) ÷ (9 * i - 17)), 2:14)
    limit = minimum(p[1] for p in mindigitsums if p[2] > maxwanted)
    arr = zeros(Int, limit)
    arr[1] = 1
    for dividend in 1:limit-1
        dsum = sum(digits(dividend))
        quo, rem = divrem(dividend, dsum)
        rem == 0 && quo < limit && (arr[quo] = 1)
    end
    for j in eachindex(arr)
        arr[j] == 0 && @yield(j)
    end
end

println("The first 50 inconsummate numbers in base 10:")
for (i, j) in enumerate(gen_inconsummate(100000))
    if i <= 50
        print(rpad(j, 6), i % 10 == 0 ? "\n" : "")
    elseif i == 1000
        println("\nThe one-thousandth inconsummate number in base 10 is $j")
    elseif i == 10000
        println("The ten-thousandth inconsummate number in base 10 is $j")
    elseif i == 100000
        println("The hundred-thousandth inconsummate number in base 10 is $j")
        break
    end
end
