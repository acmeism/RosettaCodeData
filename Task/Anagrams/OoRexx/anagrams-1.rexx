-- This assumes you've already downloaded the following file and placed it
-- in the current directory: http://wiki.puzzlers.org/pub/wordlists/unixdict.txt

-- There are several different ways of reading the file.  I chose the
-- supplier method just because I haven't used it yet in any other examples.
source = .stream~new('unixdict.txt')~supplier
-- this holds our mappings of the anagrams
anagrams = .directory~new
count = 0    -- this is used to keep track of the maximums

loop while source~available
    word = source~item
    -- this produces a string consisting of the characters in sorted order
    -- Note: the ~~ used to invoke sort makes that message return value be
    -- the target array.  The sort method does not normally have a return value.
    key = word~makearray('')~~sort~tostring("l", "")

    -- make sure we have an accumulator collection for this key
    list = anagrams[key]
    if list == .nil then do
       list = .array~new
       anagrams[key] = list
    end
    -- this word is now associate with this key
    list~append(word)
    -- and see if this is a new highest count
    count = max(count, list~items)
    source~next
end

loop letters over anagrams
    list = anagrams[letters]
    if list~items >= count then
        say letters":" list~makestring("l", ", ")
end
