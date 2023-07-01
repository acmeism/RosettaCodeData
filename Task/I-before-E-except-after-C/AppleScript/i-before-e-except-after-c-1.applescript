on ibeeac()
    script o
        property wordList : words of (read file ((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class utf8»)

        -- Subhandler called if thisWord contains either "ie" or "ei". Checks if there's an instance not preceded by "c".
        on testWithoutC(thisWord, letterPair)
            set AppleScript's text item delimiters to letterPair
            repeat with i from 1 to (count thisWord's text items) - 1
                if (text item i of thisWord does not end with "c") then return true
            end repeat
            return false
        end testWithoutC
    end script

    -- Counters: {i before e not after c, i before e after c, e before i not after c, e before i after c}.
    set {xie, cie, xei, cei} to {0, 0, 0, 0}

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "ie"
    repeat with thisWord in o's wordList
        set thisWord to thisWord's contents
        if (thisWord contains "ie") then
            if (thisWord contains "cie") then set cie to cie + 1
            if (o's testWithoutC(thisWord, "ie")) then set xie to xie + 1
        end if
        if (thisWord contains "ei") then
            if (thisWord contains "cei") then set cei to cei + 1
            if (o's testWithoutC(thisWord, "ei")) then set xei to xei + 1
        end if
    end repeat
    set AppleScript's text item delimiters to astid

    set |1 is plausible| to (xie / cie > 2)
    set |2 is plausible| to (cei / xei > 2)

    return {|"I before E not after C" is plausible|:|1 is plausible|} & ¬
        {|"E before I after C" is plausible|:|2 is plausible|} & ¬
        {|Both are plausible|:(|1 is plausible| and |2 is plausible|)}
end ibeeac

ibeeac()
