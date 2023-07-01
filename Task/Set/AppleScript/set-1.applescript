use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
--use scripting additions

on doSetTask()
    -- 'set' at the beginnings of lines is an AppleScript command; nothing to do with sets.

    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "

    set S to current application's class "NSSet"'s setWithArray:({1, 2, 3, 6, 7, 8, 9, 0})
    set end of output to "Set S:  " & (S's allObjects() as list)
    set end of output to "\"aardvark\" is a member of S:  " & ((S's containsObject:("aardvark")) as boolean)
    set end of output to "3 is a member of S:  " & ((S's containsObject:(3)) as boolean)


    set A to S's |copy|() -- or: set A to current application's class "NSSet"'s setWithArray:({1, 2, 3, 6, 7, 8, 9, 0})
    set end of output to linefeed & "Set A:  " & (A's allObjects() as list)
    set B to current application's class "NSSet"'s setWithArray:({2, 2, 2, 3, 4, 5, 6, 7, 7, 7, 8})
    set end of output to "Set B:  " & (B's allObjects() as list)

    set union to A's setByAddingObjectsFromSet:(B)
    -- Or:
    -- set union to A's mutableCopy()
    -- tell union to unionSet:(B)
    set end of output to "Union of A and B:  " & (union's allObjects() as list)

    set intersection to A's mutableCopy()
    tell intersection to intersectSet:(B)
    set end of output to "Intersection of A and B:  " & (intersection's allObjects() as list)

    set difference to A's mutableCopy()
    tell difference to minusSet:(B)
    set end of output to "Difference of A and B:  " & (difference's allObjects() as list)

    set end of output to "A is a subset of B:  " & ((A's isSubsetOfSet:(B)) as boolean)
    set end of output to "A is a subset of S:  " & ((A's isSubsetOfSet:(S)) as boolean)

    set end of output to "A is equal to B:  " & ((A's isEqualToSet:(B)) as boolean)
    set end of output to "A is equal to S:  " & ((A's isEqualToSet:(S)) as boolean)

    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end doSetTask

doSetTask()
