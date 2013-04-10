include misc.e

type ordered(sequence s)
    for i = 1 to length(s)-1 do
        -- assume all items in the sequence are atoms
        if s[i]>s[i+1] then
            return 0
        end if
    end for
    return 1
end type

integer maxlen
sequence words
object word
constant fn = open("unixdict.txt","r")
maxlen = -1

while 1 do
    word = gets(fn)
    if atom(word) then
        exit
    end if
    word = word[1..$-1] -- truncate new-line
    if length(word) >= maxlen and ordered(word) then
        if length(word) > maxlen then
            maxlen = length(word)
            words = {}
        end if
        words = append(words,word)
    end if
end while

close(fn)

pretty_print(1,words,{2})
