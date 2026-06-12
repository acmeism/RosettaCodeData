""" A simple one-liner fitting the task but lacking flexibility. """
simplesamecounts(s) = allequal(map(c -> count(==(c), s), ['a', 'b', 'c']))


"""
A more sophisticated `samecounts` function, which allows user to specify target,
whether the counting must find a least one target letter in the text, and
whether to respect or ignore letter case.

    samecounts(text, chars = ['a', 'b', 'c']; casesensitive = true, mincount = 0)

Count each occurence in text of all characters in chars, return true if the
counts are all equal, otherwise returns false. Return value may be modified by
the `casesensitive` and `mincount` arguments.

`text`: A string or similar char vector to search.

`chars`: A vector of characters. Counts are of all characters in this array.
         Defaults to 'a', 'b', and 'c'.

`casesensitive`: This named argument specifies whether counts are case sensitive.
                 Defaults to true (case sensitive, so 'A' is not counted for 'a').

`mincount`: This named argument, when < 1, as in 0 (default), specifies whether
            all counts found being zero is considered a true result (default
            when < 1) or whether such a result returns false. In addition,
            if mincount is > 1, all letters must be found as a count of
            `mincount` or greater in order for the function to return true.
"""
function samecounts(text, chars = ['a', 'b', 'c']; casesensitive = true, mincount = 0)
    (isempty(text) || isempty(chars)) && return mincount < 1
    if !casesensitive
        text = lowercase(text)
        chars = map(lowercase, chars)
    end
    counts = map(ch -> count(==(ch), text), chars)
    return counts[begin] >= mincount && allequal(counts)
end

@show simplesamecounts("back")
@show samecounts("back")
@show simplesamecounts("Back")
@show samecounts("Back", casesensitive = false)
@show simplesamecounts("")
@show samecounts("", mincount = 1)
@show simplesamecounts("gone")
@show samecounts("gone", mincount = 1)

const adawords = split(read("unixdict.txt", String), r"\s+")
for s in adawords
    samecounts(s, mincount = 1) && println(s)
end

const rakuwords = split(read("words_alpha.txt", String), r"\s+")
for s in rakuwords
    samecounts(s, mincount = 2) && println(s)
end
