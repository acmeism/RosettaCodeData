BEGIN {
	bf=ARGV[1]; ARGV[1] = ""
	compile(bf)
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
			while(1) {
				if (goteof) break
				if (!gotline) {
					gotline = getline
					if(!gotline) goteof = 1
					if (goteof) break
					line = $0
				}
				if (line == "") {
					gotline=0
					m[p]=10
					break
				}
				if (!genord) {
					for(i=1; i<256; i++)
						ord[sprintf("%c",i)] = i
					genord=1
				}
				c = substr(line, 1, 1)
				line=substr(line, 2)
				arena[p] = ord[c]
				break
			}

		} else if((i == "[" && arena[p] == 0) ||
		          (i == "]" && arena[p] != 0))
			pc = jump[pc]
		pc++
	}
}
