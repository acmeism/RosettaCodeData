on twoSum(givenNumbers, givenSum)
    script o
        property lst : givenNumbers
        property output : {}
    end script

    set listLength to (count o's lst)
    repeat with i from 1 to (listLength - 1)
        set n1 to item i of o's lst
        repeat with j from (i + 1) to listLength
            set thisSum to n1 + (item j of o's lst)
            if (thisSum = givenSum) then
                set end of o's output to {i, j}
            else if (thisSum > givenSum) then
                exit repeat
            end if
        end repeat
    end repeat

    return o's output
end twoSum

-- Test code:
twoSum({0, 2, 11, 19, 90}, 21) -- Task-specified list.
twoSum({0, 3, 11, 19, 90}, 21) -- No matches.
twoSum({-44, 0, 0, 2, 10, 11, 19, 21, 21, 21, 65, 90}, 21) -- Multiple solutions.
