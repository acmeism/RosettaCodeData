{
	scram = best_shuffle($0)
	print $0 " -> " scram " (" unchanged($0, scram) ")"
}

function best_shuffle(s,    c, i, j, len, r, t) {
	len = split(s, t, "")

	# Swap elements of t[] to get a best shuffle.
	for (i = 1; i <= len; i++) {
		for (j = 1; j <= len; j++) {
			# Swap t[i] and t[j] if they will not match
			# the original characters from s.
			if (i != j &&
			    t[i] != substr(s, j, 1) &&
			    substr(s, i, 1) != t[j]) {
				c = t[i]
				t[i] = t[j]
				t[j] = c
				break
			}
		}
	}

	# Join t[] into one string.
	r = ""
	for (i = 1; i <= len; i++)
		r = r t[i]
	return r
}

function unchanged(s1, s2,    count, len) {
	count = 0
	len = length(s1)
	for (i = 1; i <= len; i++) {
		if (substr(s1, i, 1) == substr(s2, i, 1))
			count++
	}
	return count
}
