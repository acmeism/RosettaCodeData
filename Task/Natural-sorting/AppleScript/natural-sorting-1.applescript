use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

on naturalSort(listOfText)
    -- Get doctored copies of the strings in order to get around situations that
    -- AppleScript's text comparison attributes don't handle naturally. ie. Reduce any
    -- run of white space to a single character, zap any leading/trailing space, move
    -- any article word at the beginning to the end, and replace any "ſ" or "ʒ" with "s".
    script o
        property doctored : listOfText's items
    end script

    set regex to current application's NSRegularExpressionSearch
    set substitutions to {{"\\s++", space}, {"^ | $", ""}, ¬
        {"^(?i)(The|An?) (.++)$", "$2 $1"}, {"[\\u0292\\u017f]", "s"}}
    repeat with i from 1 to (count o's doctored)
        set mutableString to (current application's class "NSMutableString"'s ¬
            stringWithString:(o's doctored's item i))
        repeat with thisSub in substitutions
            set {searchStr, replacement} to thisSub
            tell mutableString to replaceOccurrencesOfString:(searchStr) ¬
                withString:(replacement) options:(regex) range:({0, its |length|()})
        end repeat
        set o's doctored's item i to mutableString as text
    end repeat

    -- Sort the doctored strings with the relevant AppleScript comparison attributes
    -- explicitly either set or not, echoing the moves in the original list.
    considering numeric strings, white space and hyphens but ignoring diacriticals, punctuation and case
        tell sorter to sort(o's doctored, 1, -1, {slave:{listOfText}})
    end considering

    return listOfText
end naturalSort

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on tests()
    set output to {"(* Leading, trailing, and multiple white spaces ignored *)"}
    set output's end to ¬
        naturalSort({"  ignore superfluous spaces: 1-3", "ignore superfluous spaces: 1-1", ¬
            "  ignore superfluous    spaces: 1-2", "   ignore superfluous spaces: 1-4", ¬
            "ignore superfluous spaces: 1-7", "ignore superfluous    spaces: 1-5   ", ¬
            "ignore superfluous   spaces: 1-6", "   ignore    superfluous     spaces: 1-8"})

    set output's end to linefeed & "(* All white space characters treated as equivalent *)"
    set output's end to naturalSort({"Equiv. spaces: 2-6", "Equiv." & return & "spaces: 2-5", ¬
        "Equiv." & (character id 12) & "spaces: 2-4", ¬
        "Equiv." & (character id 11) & "spaces: 2-3", ¬
        "Equiv." & linefeed & "spaces: 2-2", "Equiv." & tab & "spaces: 2-1"})

    set output's end to linefeed & ¬
        "(* Case ignored. (The sort order would actually be the same with case considered,
   since case only decides the issue when the strings are otherwise identical.) *)"
    set output's end to naturalSort({"cASE INDEPENDENT: 3-1", "caSE INDEPENDENT: 3-2", ¬
        "CASE independent: 3-3", "casE INDEPENDENT: 3-4", "case INDEPENDENT: 3-5"})

    set output's end to linefeed & "(* Numerics considered by number value *)"
    set output's end to naturalSort({"foo1000bar99baz10.txt", "foo100bar99baz0.txt", ¬
        "foo100bar10baz0.txt", "foo1000bar99baz9.txt"})

    set output's end to linefeed & "(* Title sort *)"
    set output's end to ¬
        naturalSort({"The Wind in the Willows", "The 40th Step More", ¬
            "A Matter of Life and Death", "The 39 steps", ¬
            "An Inspector Calls", "Wanda"})

    set output's end to linefeed & "(* Diacriticals (and case) ignored *)"
    set output's end to naturalSort({"Equiv. " & (character id 253) & " accents: 6-1", ¬
        "Equiv. " & (character id 221) & " accents: 6-3", ¬
        "Equiv. y accents: 6-4", "Equiv. Y accents: 6-2"})

    set output's end to linefeed & "(* Ligatures *)"
    set output's end to naturalSort({(character id 306) & " ligatured", ¬
        "of", "ij no ligature", (character id 339), "od"})

    set output's end to linefeed & ¬
        "(* Custom \"s\" equivalents and Esszet (NB. Esszet normalises to \"ss\") *)"
    set output's end to naturalSort({"Start with an " & (character id 658) & ": 8-1", ¬
        "Start with an " & (character id 383) & ": 8-2", ¬
        "Start with an " & (character id 223) & ": 8-3", ¬
        "Start with an s: 8-4", "Start with an ss: 8-5"})

    return join(output, linefeed)
end tests

tests()
