on task(maxN)
    set startWith0 to false -- Change to true to start with 0 and "00".
    set rhv to -(startWith0 as integer) -- Start value of "right hand" string.
    script o
        property bits : {rhv}
        property output : {}
    end script

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    repeat
        -- Add 1 to the binary-digit list's LSD and perform any carries.
        set carry to 1
        repeat with i from (count o's bits) to 1 by -1
            set columnSum to (item i of o's bits) + carry
            set item i of o's bits to columnSum mod 2
            set carry to columnSum div 2
            if (carry = 0) then exit repeat
        end repeat
        if (carry = 1) then set beginning of o's bits to carry
        -- Add 1 to the "right-hand" value and work out the corresponding n.
        set rhv to rhv + 1
        set n to rhv * (2 ^ (count o's bits)) div 1 + rhv
        -- Unless n exceeds maxN, append it and its binary form to the output.
        if (n > maxN) then exit repeat
        set end of o's output to (n as text) & ":  " & o's bits & o's bits
    end repeat
    set AppleScript's text item delimiters to linefeed
    set o's output to o's output as text
    set AppleScript's text item delimiters to astid

    return o's output
end task

task(999)
