use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script ¬
	"Custom Iterative Ternary Merge Sort" -- <https://www.macscripter.net/t/timsort-and-nigsort/71383/3>
use scripting additions

-- Return the n number of an n-isogram or 0 for a non-isogram.
on isogramicity(wrd)
    set chrCount to (count wrd)
    if (chrCount < 2) then return chrCount
    set chrs to wrd's characters
    tell sorter to sort(chrs, 1, chrCount, {})

    set i to 1
    set currentChr to chrs's beginning
    repeat with j from 2 to chrCount
        set testChr to chrs's item j
        if (testChr ≠ currentChr) then
            if (i = 1) then
                set n to j - i -- First character's instance count.
            else if (j - i ≠ n) then
                return 0 -- Instance count mismatch.
            end if
            set i to j
            set currentChr to testChr
        end if
    end repeat
    if (i = 1) then return chrCount -- All characters the same.
    if (chrCount - i + 1 ≠ n) then return 0 -- Mismatch with last character.
    return n
end isogramicity

on task()
    script o
        property wrds : paragraphs of ¬
            (read file ((path to desktop as text) & "unixdict.txt") as «class utf8»)
        property isograms : {{}, {}, {}, {}, {}} -- Allow for up to 5-isograms.

        -- Sort customisation handler to order the words as required.
        on isGreater(a, b)
            set ca to (count a)
            set cb to (count b)
            if (ca = cb) then return (a > b)
            return (ca < cb)
        end isGreater
    end script

    ignoring case -- A mere formality. It's the default and unixdict.txt is single-cased anyway!
        repeat with i from 1 to (count o's wrds)
            set thisWord to o's wrds's item i
            set n to isogramicity(thisWord)
            if (n > 0) then set end of o's isograms's item n to thisWord
        end repeat
        repeat with thisList in o's isograms
            tell sorter to sort(thisList, 1, -1, {comparer:o})
        end repeat
    end ignoring

    set output to {"N-isograms where n > 1:"}
    set n_isograms to {}
    repeat with i from (count o's isograms) to 2 by -1
        set n_isograms to n_isograms & o's isograms's item i
    end repeat
    set wpl to 6 -- Words per line.
    repeat with i from 1 to (count n_isograms)
        set n_isograms's item i to text 1 thru 10 of ((n_isograms's item i) & "          ")
        set wtg to i mod wpl -- Words to go to in this line.
        if (wtg = 0) then set end of output to join(n_isograms's items (i - wpl + 1) thru i, "")
    end repeat
    if (wtg > 0) then set end of output to join(n_isograms's items -wtg thru i, "")

    set end of output to linefeed & "Heterograms with more than 10 characters:"
    set n_isograms to o's isograms's beginning
    set wpl to 4
    repeat with i from 1 to (count n_isograms)
        set thisWord to n_isograms's item i
        if ((count thisWord) < 11) then exit repeat
        set n_isograms's item i to text 1 thru 15 of (thisWord & "    ")
        set wtg to i mod wpl
        if (wtg = 0) then set end of output to join(n_isograms's items (i - wpl + 1) thru i, "")
    end repeat
    if (wtg > 0) then set end of output to join(n_isograms's items (i - wtg) thru (i - 1), "")

    return join(output, linefeed)
end task

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join


task()
