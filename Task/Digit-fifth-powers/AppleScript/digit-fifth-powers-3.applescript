on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on digit5thPowers()
    set hits to {}
    set total to 0
    repeat with d1 from 1 to 9
        set s1 to (d1 ^ 5)
        repeat with d2 from 1 to d1
            set s2 to s1 + (d2 ^ 5)
            repeat with d3 from 0 to d2
                set s3 to s2 + (d3 ^ 5)
                repeat with d4 from 0 to d3
                    set s4 to s3 + (d4 ^ 5)
                    repeat with d5 from 0 to d4
                        set s5 to s4 + (d5 ^ 5)
                        repeat with d6 from 0 to d5
                            set sum to s5 + (d6 ^ 5) as integer
                            set temp to sum
                            set d to temp mod 10
                            set digits to {d1, d2, d3, d4, d5, d6}
                            repeat while (digits contains {d})
                                repeat with i from 1 to 6
                                    if (digits's item i = d) then
                                        set digits's item i to missing value
                                        exit repeat
                                    end if
                                end repeat
                                set temp to temp div 10
                                set d to temp mod 10
                            end repeat
                            if (((count digits each integer) = 0) and (sum > (2 ^ 5))) then
                                set end of hits to sum
                                set total to total + sum
                            end if
                        end repeat
                    end repeat
                end repeat
            end repeat
        end repeat
    end repeat
    return join(hits, " + ") & " = " & total
end digit5thPowers

digit5thPowers()
