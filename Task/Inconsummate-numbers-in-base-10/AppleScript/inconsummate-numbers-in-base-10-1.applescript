on inconsummateNumbers(numberRequired)
    set limit to numberRequired * 1000 -- Seems to be enough.
    script o
        property lst : makeList(limit, true)
    end script

    repeat with n from 11 to limit -- 1 to 10 obviously can't be inconsummate.
        set digitSum to n mod 10
        set temp to n div 10
        repeat while (temp > 9)
            set digitSum to digitSum + temp mod 10
            set temp to temp div 10
        end repeat
        set digitSum to digitSum + temp

        tell (n div digitSum) to if (it = n / digitSum) then set o's lst's item it to false
    end repeat

    set i to 0
    repeat with n from 11 to limit
        if (o's lst's item n) then
            set i to i + 1
            set o's lst's item i to n
            if (i = numberRequired) then return o's lst's items 1 thru i
        end if
    end repeat

    return {}
end inconsummateNumbers

on makeList(limit, filler)
    if (limit < 1) then return {}
    script o
        property lst : {filler}
    end script

    set counter to 1
    repeat until (counter + counter > limit)
        set o's lst to o's lst & o's lst
        set counter to counter + counter
    end repeat
    if (counter < limit) then set o's lst to o's lst & o's lst's items 1 thru (limit - counter)
    return o's lst
end makeList

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    script o
        property inconsummates : inconsummateNumbers(100000)
    end script
    set output to {"First 50 inconsummate numbers:"}
    set row to {}
    repeat with i from 1 to 50
        set row's end to text -5 thru -1 of ("   " & o's inconsummates's item i)
        if (i mod 10 = 0) then
            set output's end to join(row, "")
            set row to {}
        end if
    end repeat
    set output's end to linefeed & "1,000th inconsummate number: " & o's inconsummates's item 1000
    set output's end to "10,000th inconsummate number: " & o's inconsummates's item 10000
    set output's end to "100,000th inconsummate number: " & o's inconsummates's end
    return join(output, linefeed)
end task

task()
