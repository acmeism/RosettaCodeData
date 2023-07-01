on threeWayPartition(theList, order) -- Dijkstra's algorithm.
    script o
        property lst : theList
    end script

    set {v1, v2, v3} to order
    set {i, j, k} to {1, 1, (count o's lst)}
    repeat until (j > k)
        set this to o's lst's item j
        if (this = v3) then
            set o's lst's item j to o's lst's item k
            set o's lst's item k to this
            set k to k - 1
        else
            if (this = v1) then
                set o's lst's item j to o's lst's item i
                set o's lst's item i to this
                set i to i + 1
            end if
            set j to j + 1
        end if
    end repeat

    return -- Input list sorted in place.
end threeWayPartition

on DutchNationalFlagProblem(numberOfBalls)
    script o
        property balls : {}
    end script

    set colours to {"red", "white", "blue"}
    repeat numberOfBalls times
        set end of o's balls to some item of colours
    end repeat
    threeWayPartition(o's balls, colours)

    return o's balls
end DutchNationalFlagProblem

DutchNationalFlagProblem(100)
