include sort.e

function compare_keys(sequence a, sequence b)
    return compare(a[1],b[1])
end function

constant fn = open("unixdict.txt","r")
sequence words, anagrams
object word
words = {}
while 1 do
    word = gets(fn)
    if atom(word) then
        exit
    end if
    word = word[1..$-1] -- truncate new-line character
    words = append(words, {sort(word), word})
end while
close(fn)

integer maxlen
maxlen = 0
words = custom_sort(routine_id("compare_keys"), words)
anagrams = {words[1]}
for i = 2 to length(words) do
    if equal(anagrams[$][1],words[i][1]) then
        anagrams[$] = append(anagrams[$], words[i][2])
    elsif length(anagrams[$]) = 2 then
        anagrams[$] = words[i]
    else
        if length(anagrams[$]) > maxlen then
            maxlen = length(anagrams[$])
        end if
        anagrams = append(anagrams, words[i])
    end if
end for
if length(anagrams[$]) = 2 then
    anagrams = anagrams[1..$-1]
end if

for i = 1 to length(anagrams) do
    if length(anagrams[i]) = maxlen then
        for j = 2 to length(anagrams[i]) do
            puts(1,anagrams[i][j])
            puts(1,' ')
        end for
        puts(1,"\n")
    end if
end for
