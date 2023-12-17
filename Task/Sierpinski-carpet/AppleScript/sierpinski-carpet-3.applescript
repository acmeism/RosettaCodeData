on SierpinskiCarpet(n, char)
    if (n < 0) then return {}
    script o
        property lst1 : {char}
        property lst2 : missing value
    end script

    set gap to space
    repeat with k from 0 to (n - 1)
        copy o's lst1 to o's lst2
        repeat with i from 1 to (3 ^ k)
            set str to o's lst1's item i
            set o's lst1's item i to str & str & str
            set o's lst2's item i to str & gap & str
        end repeat
        set o's lst1 to o's lst1 & o's lst2 & o's lst1
        set gap to gap & gap & gap
    end repeat

    return join(o's lst1, linefeed)
end SierpinskiCarpet

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

return SierpinskiCarpet(3, "#")
