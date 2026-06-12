function incremental(text, letters; casesensitive = true, minfirstcount = 1)
    if !casesensitive
        text = lowercase(text)
        letters = map(lowercase, letters)
    end
    counts = map(c -> count(==(c), text), letters) |> sort!
    return !isempty(counts) && counts[begin] >= minfirstcount && all(==(1), diff(counts))
end

const uwords = split(read("unixdict.txt", String), r"\s+")
const awords = split(read("words_alpha.txt", String), r"\s+")
const tests = [
   (uwords, ['a', 'b', 'c'], 1), (uwords, ['t', 'h', 'e'], 1), (uwords, ['c', 'i', 'o'], 2),
   (awords, ['a', 'b', 'c'], 2), (awords, ['t', 'h', 'e'], 2), (awords, ['c', 'i', 'o'], 3),
]

for (wordlist, chars, minreq) in tests
	fname = wordlist == uwords ? "unixdict.txt" : "words_alpha.txt"
	println("Filtering $fname for letters <$(String(chars))> and minimum count $minreq:")
	results = filter(s -> incremental(s, chars, minfirstcount = minreq), wordlist)
	println(isempty(results) ? "<none>" : join(results, "\n"), "\n")
end
