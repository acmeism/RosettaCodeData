on sieveOfEratosthenes(limit)
    script o
        property numberList : {missing value}
    end script

    repeat with n from 2 to limit
        set end of o's numberList to n
    end repeat
    repeat with n from 2 to (limit ^ 0.5 div 1)
        if (item n of o's numberList is n) then
            repeat with multiple from (n * n) to limit by n
                set item multiple of o's numberList to missing value
            end repeat
        end if
    end repeat

    return o's numberList's numbers
end sieveOfEratosthenes

sieveOfEratosthenes(1000)
