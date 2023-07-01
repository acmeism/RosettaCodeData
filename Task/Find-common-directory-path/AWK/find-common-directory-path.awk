# Finds the longest common directory of paths[1], paths[2], ...,
# paths[count], where sep is a single-character directory separator.
function common_dir(paths, count, sep,    b, c, f, i, j, p) {
	if (count < 1)
		return ""

	p = ""	# Longest common prefix
	f = 0	# Final index before last sep

	# Loop for c = each character of paths[1].
	for (i = 1; i <= length(paths[1]); i++) {
		c = substr(paths[1], i, 1)

		# If c is not the same in paths[2], ..., paths[count]
		# then break both loops.
		b = 0
		for (j = 2; j <= count; j++) {
			if (c != substr(paths[j], i, 1)) {
				b = 1
				break
			}
		}
		if (b)
			break

		# Append c to prefix. Update f.
		p = p c
		if (c == sep)
			f = i - 1
	}

	# Return only f characters of prefix.
	return substr(p, 1, f)
}

BEGIN {
	a[1] = "/home/user1/tmp/coverage/test"
	a[2] = "/home/user1/tmp/covert/operator"
	a[3] = "/home/user1/tmp/coven/members"
	print common_dir(a, 3, "/")
}
