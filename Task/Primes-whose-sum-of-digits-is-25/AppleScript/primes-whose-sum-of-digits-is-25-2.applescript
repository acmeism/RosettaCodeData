on sieveOfEratosthenes(limit)
    script o
        property numberList : {missing value}
    end script

    repeat with n from 2 to limit
        set end of o's numberList to n
    end repeat

    repeat with n from 2 to (limit ^ 0.5) div 1
        if (item n of o's numberList is n) then
            repeat with multiple from n * n to limit by n
                set item multiple of o's numberList to missing value
            end repeat
        end if
    end repeat

    return o's numberList's numbers
end sieveOfEratosthenes

on sumOfDigits(n) -- n assumed to be a positive decimal integer.
    set sum to n mod 10
    set n to n div 10
    repeat until (n = 0)
        set sum to sum + n mod 10
        set n to n div 10
    end repeat

    return sum
end sumOfDigits

on numbersWhoseDigitsSumTo(numList, targetSum)
    script o
        property numberList : numList
        property output : {}
    end script

    repeat with n in o's numberList
        if (sumOfDigits(n) = targetSum) then set end of o's output to n's contents
    end repeat

    return o's output
end numbersWhoseDigitsSumTo

-- Task code:
return numbersWhoseDigitsSumTo(sieveOfEratosthenes(4999), 25)
