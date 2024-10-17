using Dates

function datepalindromes(nextcount=20)
    println("Date palindromes:")
    count, d = 0, Date(1000, 1, 1)
    for year in 2021:9200
        try
            dig = digits(year)
            month = 10 * dig[1] + dig[2]
            day = 10 * dig[3] + dig[4]
            d = Date(year, month, day)
        catch
            continue
        end
        println(d)
        count += 1
        if count >= nextcount
            break
        end
    end
end

datepalindromes()
