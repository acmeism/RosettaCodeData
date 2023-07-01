on equilibriumIndices(sequence)
    script o
        property seq : sequence
        property output : {}
    end script

    set loSum to 0
    set hiSum to 0
    repeat with value in o's seq
        set hiSum to hiSum + value
    end repeat
    repeat with i from 1 to (count o's seq)
        set value to o's seq's item i
        set hiSum to hiSum - value
        if (hiSum = loSum) then set o's output's end to i
        set loSum to loSum + value
    end repeat

    return o's output
end equilibriumIndices

equilibriumIndices({-7, 1, 5, 2, -4, 3, 0})
