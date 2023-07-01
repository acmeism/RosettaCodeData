define countSubstring(str::string, substr::string)::integer => {
	local(i = 1, foundpos = -1, found = 0)
	while(#i < #str->size && #foundpos != 0) => {
		protect => {
			handle_error => { #foundpos = 0 }
			#foundpos = #str->find(#substr, -offset=#i)
		}
		if(#foundpos > 0) => {
			#found += 1
			#i = #foundpos + #substr->size
		else
			#i++
		}
	}
	return #found
}
define countSubstring_bothways(str::string, substr::string)::integer => {
	local(found = countSubstring(#str,#substr))
	#str->reverse
	local(found2 = countSubstring(#str,#substr))
	#found > #found2 ? return #found | return #found2
}
countSubstring_bothways('the three truths','th')
//3
countSubstring_bothways('ababababab','abab')
//2
