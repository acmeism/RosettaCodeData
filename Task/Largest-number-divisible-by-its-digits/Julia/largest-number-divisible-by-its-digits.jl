function main()
    num = 9876432
    dif = [4, 2, 2, 2]
    local k = 1
    @label start
    local str = dec(num)
    for (i, ch) in enumerate(str)
        if ch in ('0', '5') || num % (ch - '0') != 0
            num -= dif[k]
            k = (k + 1) % 4 + 1
            @goto start
        end
        for j in i+1:endof(str)
            if str[i] == str[j]
                num -= dif[k]
                k = (k + 1) % 4 + 1
                @goto start
            end
        end
    end

    return num
end

println("Number found: ", main())
