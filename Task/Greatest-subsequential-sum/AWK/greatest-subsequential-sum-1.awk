# Finds the subsequence of ary[1] to ary[len] with the greatest sum.
# Sets subseq[1] to subseq[n] and returns n. Also sets subseq["sum"].
# An empty subsequence has sum 0.
function maxsubseq(subseq, ary, len,    b, bp, bs, c, cp, i) {
	b = 0		# best sum
	c = 0		# current sum
	bp = 0		# position of best subsequence
	bn = 0		# length of best subsequence
	cp = 1		# position of current subsequence

	for (i = 1; i <= len; i++) {
		c += ary[i]
		if (c < 0) {
			c = 0
			cp = i + 1
		}
		if (c > b) {
			b = c
			bp = cp
			bn = i + 1 - cp
		}
	}

	for (i = 1; i <= bn; i++)
		subseq[i] = ary[bp + i - 1]
	subseq["sum"] = b
	return bn
}
