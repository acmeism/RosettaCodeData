startswith("abcd","ab")            #returns true
findfirst("ab", "abcd")            #returns 1:2, indices range where string was found
endswith("abcd","zn")              #returns false
match(r"ab","abcd") != Nothing     #returns true where 1st arg is regex string
for r in eachmatch(r"ab","abab")
	println(r.offset)
end                                #returns 1, then 3 matching the two starting indices where the substring was found
