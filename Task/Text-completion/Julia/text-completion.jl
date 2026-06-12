using StringDistances

const fname = download("https://www.mit.edu/~ecprice/wordlist.10000", "wordlist10000.txt")
const words = read(fname, String) |> split .|> strip .|> string
const wrd = "complition"

levdistof(n, string) = filter(w -> Levenshtein()(string, w) == n, words)

for n in 1:4
    println("Words at Levenshtein distance of $n (",
        100 - Int(round(100 * n / length(wrd))), "% similarity) from \"$wrd\": \n",
        levdistof(n, wrd), "\n")
end
