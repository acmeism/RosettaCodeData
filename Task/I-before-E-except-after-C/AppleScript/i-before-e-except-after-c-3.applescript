use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on ibeeac()
    set wordList to words of ¬
        (read (((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as «class furl») as «class utf8»)
    set wordArray to current application's class "NSArray"'s arrayWithArray:(wordList)
    set counters to {}
    repeat with letterPair in {"ie", "ei"}
        set filter to (current application's class "NSPredicate"'s ¬
            predicateWithFormat_("(self CONTAINS[c] %@)", letterPair))
        set relevants to (wordArray's filteredArrayUsingPredicate:(filter))
        set filter to (current application's class "NSPredicate"'s ¬
            predicateWithFormat_("NOT (self CONTAINS[c] %@)", "c" & letterPair))
        set end of counters to (relevants's filteredArrayUsingPredicate:(filter))'s |count|()
        set filter to (current application's class "NSPredicate"'s ¬
            predicateWithFormat_("(self CONTAINS[c] %@)", "c" & letterPair))
        set end of counters to (relevants's filteredArrayUsingPredicate:(filter))'s |count|()
    end repeat
    set {xie, cie, xei, cei} to counters
    set |1 is plausible| to (xie / cie > 2)
    set |2 is plausible| to (cei / xei > 2)

    return {|"I before E not after C" is plausible|:|1 is plausible|} & ¬
        {|"E before I after C" is plausible|:|2 is plausible|} & ¬
        {|Both are plausible|:(|1 is plausible| and |2 is plausible|)}
end ibeeac

ibeeac()
