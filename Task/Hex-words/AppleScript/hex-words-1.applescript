use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

on hexToInt(hex)
    set digits to "0123456789ABCDEF"
    set n to 0
    set astid to AppleScript's text item delimiters
    ignoring case
        repeat with thisDigit in hex
            set AppleScript's text item delimiters to thisDigit
            set n to n * 16 + (count digits's first text item)
        end repeat
    end ignoring
    set AppleScript's text item delimiters to astid
    return n
end hexToInt

on digitalRoot(r, base)
    repeat until (r < base)
        set n to r
        set r to 0
        repeat until (n = 0)
            set r to r + n mod base
            set n to n div base
        end repeat
    end repeat
    return r as integer
end digitalRoot

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set ca to current application
    set unixdictPath to (path to desktop as text) & "unixdict.txt"
    set allWords to (read (unixdictPath as «class furl») from 1 as «class utf8»)'s words
    set hexwordFilter to ca's class "NSPredicate"'s ¬
        predicateWithFormat:("self MATCHES '^[a-f]{4,}+$'")
    set hexwords to ((ca's class "NSArray"'s arrayWithArray:(allWords))'s ¬
        filteredArrayUsingPredicate:(hexwordFilter))

    set {list1, list2} to {{}, {}}
    repeat with thisWord in hexwords
        set thisWord to thisWord as text
        set decimal to hexToInt(thisWord)
        set root to digitalRoot(decimal, 10)
        set thisEntry to {thisWord, decimal, root}
        set end of list1 to thisEntry
        set distinctChars to (ca's class "NSSet"'s setWithArray:(thisWord's characters))
        if (distinctChars's |count|() > 3) then set end of list2 to thisEntry
    end repeat

    -- Sort list1 on its sublists' digital root values.
    script
        on isGreater(a, b)
            return (a's end > b's end)
        end isGreater
    end script
    tell sorter to sort(list1, 1, -1, {comparer:result})
    -- Reverse sort list2 on its sublists' decimal equivalent values.
    script
        on isGreater(a, b)
            return (a's 2nd item < b's 2nd item)
        end isGreater
    end script
    tell sorter to sort(list2, 1, -1, {comparer:result})

    -- Format for display and output.
    set padding to "          "
    repeat with thisList in {list1, list2}
        repeat with thisEntry in thisList
            tell thisEntry to set its contents to ¬
                text 1 thru 9 of (its beginning & padding) & ¬
                text -9 thru -1 of (padding & its 2nd item) & ¬
                text -9 thru -1 of (padding & its end)
        end repeat
        set thisList's beginning to "
Word       Decimal      Root
----------------------------"
    end repeat
    set beginning of list1 to linefeed & ((count list1) - 1) & ¬
        " 4+-character hexwords, sorted on their decimal equivalents' digital roots:"
    set beginning of list2 to linefeed & "The " & ((count list2) - 1) & ¬
        " with at least 4 /different/ characters, reverse sorted on their decimal equivalents:"

    return join({list1, list2}, linefeed)
end task

task()
