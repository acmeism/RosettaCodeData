on rootMeanSquare(listOfNumbers)
    script o
        property lst : listOfNumbers
    end script
    set r to 0.0
    repeat with n in o's lst
        set r to r + (n ^ 2)
    end repeat

    return (r / (count o's lst)) ^ 0.5
end rootMeanSquare

rootMeanSquare({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
