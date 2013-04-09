# out["string"] = best shuffle of string _s_
# out["score"] = number of matching characters
function best_shuffle(out, s,    c, i, j, k, klen, p, pos, set, rlen, slen) {
	slen = length(s)
	for (i = 1; i <= slen; i++) {
		c = substr(s, i, 1)

		# _set_ of all characters in _s_, with count
		set[c] += 1

		# _pos_ classifies positions by letter,
		# such that pos[c, 1], pos[c, 2], ..., pos[c, set[c]]
		# are the positions of _c_ in _s_.
		pos[c, set[c]] = i
	}

	# k[1], k[2], ..., k[klen] sorts letters from low to high count
	klen = 0
	for (c in set) {
		# insert _c_ into _k_
		i = 1
		while (i <= klen && set[k[i]] <= set[c])
			i++              # find _i_ to sort by insertion
		for (j = klen; j >= i; j--)
			k[j + 1] = k[j]  # make room for k[i]
		k[i] = c
		klen++
	}

	# Fill pos[slen], ..., pos[3], pos[2], pos[1] with positions
	# in the order that we want to fill them.
	i = 1
	while (i <= slen) {
		for (j = 1; j <= klen; j++) {
			c = k[j]
			if (set[c] > 0) {
				pos[i] = pos[c, set[c]]
				i++
				delete pos[c, set[c]]
				set[c]--
			}				
		}
	}

	# Now fill in _new_ with _letters_ according to each position
	# in pos[slen], ..., pos[1], but skip ahead in _letters_
	# if we can avoid matching characters that way.
	rlen = split(s, letters, "")
	for (i = slen; i >= 1; i--) {
		j = 1
		p = pos[i]
		while (letters[j] == substr(s, p, 1) && j < rlen)
			j++
		for (new[p] = letters[j]; j < rlen; j++)
			letters[j] = letters[j + 1]
		delete letters[rlen]
		rlen--
	}

	out["string"] = ""
	for (i = 1; i <= slen; i++) {
		out["string"] = out["string"] new[i]
	}

	out["score"] = 0
	for (i = 1; i <= slen; i++) {
		if (new[i] == substr(s, i, 1))
			out["score"]++
	}
}

BEGIN {
	count = split("abracadabra seesaw elk grrrrrr up a", words)
	for (i = 1; i <= count; i++) {
		best_shuffle(result, words[i])
		printf "%s, %s, (%d)\n",
		    words[i], result["string"], result["score"]
	}
}
