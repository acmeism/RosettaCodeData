on juggler(n)
    script o
        property sequence : {n}
    end script

    set i to 1
    set {max, pos} to {n, i}
    repeat until (n = 1)
        set n to n ^ (n mod 2 + 0.5) div 1
        set end of o's sequence to n
        set i to i + 1
        if (n > max) then set {max, pos} to {n, i}
    end repeat

    return {n:n, sequence:o's sequence, |length|:i, max:max, maxPos:pos}
end juggler

on intToText(n)
    if (n < 2 ^ 29) then return n as integer as text
    set lst to {n mod 10 as integer}
    set n to n div 10
    repeat until (n = 0)
        set beginning of lst to n mod 10 as integer
        set n to n div 10
    end repeat

    return join(lst, "")
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {}
    repeat with n from 20 to 39
        set {|length|:len, max:max, maxPos:pos} to juggler(n)
        set end of output to join({n, ": l[n] = ", len - 1, ", h[n] = ", intToText(max), ", i[n] = ", pos - 1}, "")
    end repeat

    return join(output, linefeed)
end task

task()
