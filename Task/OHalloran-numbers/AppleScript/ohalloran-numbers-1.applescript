on OHalloranNumbers(max)
    script o
        property evens : {missing value, missing value}
    end script
    repeat with n from 6 to max by 2
        set end of o's evens to n
    end repeat
    set halfMax to max div 2
    set sixthMax to halfMax div 3
    repeat with x from 1 to sixthMax
        repeat with y from x to (sixthMax div x)
            repeat with halfArea from ((x + x + y) * y) to halfMax by (x + y)
                set o's evens's item halfArea to missing value
            end repeat
        end repeat
    end repeat
    return o's evens's integers
end OHalloranNumbers

OHalloranNumbers(1000 - 1)

(* Repeat logic condensed from:
    repeat with x from 1 to sixthMax
        repeat with y from x to sixthMax
            set xy to x * y
            if (xy > sixthMax) then exit repeat
            repeat with z from y to sixthMax
                set halfArea to xy + (x + y) * z
                if (halfArea > halfMax) then exit repeat
                set o's evens's item halfArea to missing value
            end repeat
        end repeat
    end repeat
*)
