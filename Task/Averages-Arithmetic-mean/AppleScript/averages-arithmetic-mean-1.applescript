on average(listOfNumbers)
    set len to (count listOfNumbers)
    if (len is 0) then return missing value

    set sum to 0
    repeat with thisNumber in listOfNumbers
        set sum to sum + thisNumber
    end repeat

    return sum / len
end average

average({2500, 2700, 2400, 2300, 2550, 2650, 2750, 2450, 2600, 2400})
