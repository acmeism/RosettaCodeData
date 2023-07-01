on listAComesBeforeListB(a, b)
    set aLength to (count a)
    set bLength to (count b)
    set i to 0
    repeat
        set i to i + 1
        if (i > bLength) then
            return false
        else if (i > aLength) then
            return true
        else
            set aVal to item i of a
            set bVal to item i of b
            if (aVal = bVal) then
            else
                return (bVal > aVal)
            end if
        end if
    end repeat
end listAComesBeforeListB

-- Test code:
set a to {}
repeat (random number 10) times
    set end of a to random number 10
end repeat
set b to {}
repeat (random number 10) times
    set end of b to random number 10
end repeat

return {a:a, b:b, | a < b |: listAComesBeforeListB(a, b)},
