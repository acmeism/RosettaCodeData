-- This assumes you've already downloaded the following file and placed it
-- in the current directory: http://wiki.puzzlers.org/pub/wordlists/unixdict.txt

-- There are several different ways of reading the file.  I chose the
-- supplier method just because I haven't used it yet in any other examples.
source = .stream~new('unixdict.txt')~supplier
-- this holds our mappings of the anagrams.  This is good use for the
-- relation class
anagrams = .relation~new
count = 0    -- this is used to keep track of the maximums

loop while source~available
    word = source~item
    -- this produces a string consisting of the characters in sorted order
    -- Note: the ~~ used to invoke sort makes that message return value be
    -- the target array.  The sort method does not normally have a return value.
    key = word~makearray('')~~sort~tostring("l", "")
    -- add this to our mapping.  This creates multiple entries for each
    -- word that uses the same key
    anagrams[key] = word
    source~next
end

-- now get the set of unique keys
keys = .set~new~~putall(anagrams~allIndexes)
count = 0    -- this is used to keep track of the maximums
most = .directory~new

loop key over keys
    words = anagrams~allAt(key)
    newCount = words~items
    if newCount > count then do
        -- throw away our old set
        most~empty
        count = newCount
        most[key] = words
    end
    -- matches our highest count, add it to the list
    else if newCount == count then
        most[key] = words
end

loop letters over most
    words = most[letters]
    say letters":" words~makestring("l", ", ")
end
