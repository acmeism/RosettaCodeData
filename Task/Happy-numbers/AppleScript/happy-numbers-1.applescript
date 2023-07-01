on run
    set howManyHappyNumbers to 8
    set happyNumberList to {}
    set globalCounter to 1

    repeat howManyHappyNumbers times
        repeat while not isHappy(globalCounter)
            set globalCounter to globalCounter + 1
        end repeat
        set end of happyNumberList to globalCounter
        set globalCounter to globalCounter + 1
    end repeat
    log happyNumberList
end run

on isHappy(numberToCheck)
    set localCycle to {}
    repeat while (numberToCheck ≠ 1)
        if localCycle contains numberToCheck then
            exit repeat
        end if
        set end of localCycle to numberToCheck
        set tempNumber to 0
        repeat while (numberToCheck > 0)
            set digitOfNumber to numberToCheck mod 10
            set tempNumber to tempNumber + (digitOfNumber ^ 2)
            set numberToCheck to (numberToCheck - digitOfNumber) / 10
        end repeat
        set numberToCheck to tempNumber
    end repeat
    return (numberToCheck = 1)
end isHappy
