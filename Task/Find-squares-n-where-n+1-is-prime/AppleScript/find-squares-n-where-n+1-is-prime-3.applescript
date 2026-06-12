on task()
    set output to {1}
    set nPlus1 to 5
    repeat with d from 12 to (1000 ^ 0.5 div 0.25) by 8
        if (isPrime(nPlus1)) then set end of output to nPlus1 - 1
        set nPlus1 to nPlus1 + d
    end repeat

    return output
end task
