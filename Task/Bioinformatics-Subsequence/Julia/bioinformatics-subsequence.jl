DNArand(n, bases=['A', 'T', 'C', 'G']) = String(rand(bases, n))

DNAsearch(needle, haystack, lap=true) =  findall(needle, haystack, overlap=lap)

const rand_string = DNArand(200)
const subseq = DNArand(4)

println("Search sequence:\n$rand_string\nfor substring $subseq. Found at positions: ")
foreach(p -> print(rpad(p[2], 8), p[1] % 10 == 0 ? "\n" : ""), enumerate(DNAsearch(subseq, rand_string)))
