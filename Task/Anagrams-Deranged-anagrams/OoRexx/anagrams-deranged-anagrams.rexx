-- This assumes you've already downloaded the following file and placed it
-- in the current directory: http://www.puzzlers.org/pub/wordlists/unixdict.txt

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
-- the longest count tracker
longest = 0
-- our list of the longest pairs
pairs = .array~new

loop key over keys
    -- don't even bother doing the deranged checks for any key
    -- shorter than our current longest
    if key~length < longest then iterate

    words = anagrams~allAt(key)
    -- singletons aren't anagrams at all
    newCount = words~items
    loop i = 1 to newCount - 1
        word1 = words[i]
        loop j = 1 to newCount
            word2 = words[j]
            -- bitxor will have '00'x in every position where these
            -- strings match.  If found, go around and check the
            -- next one
            if word1~bitxor(word2)~pos('00'x) > 0 then iterate
            -- we have a match
            else do
                if word1~length > longest then do
                    -- throw away anything we've gathered so far
                    pairs~empty
                    longest = word1~length
                end
                pairs~append(.array~of(word1, word2))
            end
        end
    end
end

say "The longest deranged anagrams we found are:"
loop pair over pairs
     say pair[1] pair[2]
end
