on canMakeWordWithBlocks(theString, theBlocks)
    set stringLen to (count theString)
    copy theBlocks to theBlocks
    script o
        on cmw(c, theBlocks)
            set i to 1
            repeat until (i > (count theBlocks))
                if (character c of theString is in item i of theBlocks) then
                    if (c = stringLen) then return true
                    set item i of theBlocks to missing value
                    set theBlocks to text of theBlocks
                    if (cmw(c + 1, theBlocks)) then return true
                end if
                set i to i + 1
            end repeat

            return false
        end cmw
    end script

    ignoring case -- Make the default case insensitivity explicit.
        return ((theString = "") or (o's cmw(1, theBlocks)))
    end ignoring
end canMakeWordWithBlocks

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set blocks to {"BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS", ¬
        "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"}
    set output to {}
    repeat with testWord in {"a", "bark", "book", "treat", "common", "squad", "confuse"}
        set end of output to "Can make “" & testWord & "”: " & ¬
            canMakeWordWithBlocks(testWord's contents, blocks)
    end repeat
    return join(output, linefeed)
end task

task()
