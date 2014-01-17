BEGIN {
	compile(ARGV[1])
	execute()
}

# Strips non-instructions, builds the jump table.
function compile(s,   i,j,k,f) {
	c = split(s, src, "")
	j = 0
	for(i = 1; i <= c; i++) {
		if(src[i] ~ /[\-\+\[\]\<\>,\.]/)
			code[j++] = src[i]

		if(src[i] == "[") {
			marks[j] = 1
		} else if(src[i] == "]") {
			f = 0
			for(k = j; k > 0; k--) {
				if(k in marks) {
					jump[k-1] = j - 1
					jump[j-1] = k - 1
					f = 1
					delete marks[k]
					break
				}
			}
			if(!f) {
				print "Unmatched ]"
				exit 1
			}
		}
	}
}

function execute(   pc,p,i) {
	pc = p = 0
	while(pc in code) {
		i = code[pc]

		if(i == "+")
			arena[p]++
		else if(i == "-")
			arena[p]--
		else if(i == "<")
			p--
		else if(i == ">")
			p++
		else if(i == ".")
			printf("%c", arena[p])
		else if(i == ",") {
			"dd bs=1 count=1 2>/dev/null | xd -1d" | getline
			sub(/^0*/, "", $2)
			arena[p] = 0 + $2
			close("dd bs=1 count=1 2>/dev/null | xd -1d")
		} else if((i == "[" && arena[p] == 0) ||
		          (i == "]" && arena[p] != 0))
			pc = jump[pc]
		pc++
	}
}
