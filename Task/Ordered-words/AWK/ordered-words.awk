BEGIN {
	abc = "abcdefghijklmnopqrstuvwxyz"
}

{
	# Check if this line is an ordered word.
	ordered = 1  # true
	left = -1
	for (i = 1; i <= length($0); i++) {
		right = index(abc, substr($0, i, 1))
		if (right == 0 || left > right) {
			ordered = 0  # false
			break
		}
		left = right
	}

	if (ordered) {
		score = length($0)
		if (score > best["score"]) {
			# Reset the list of best ordered words.
			best["score"] = score
			best["count"] = 1
			best[1] = $0
		} else if (score == best["score"]) {
			# Add this word to the list.
			best[++best["count"]] = $0
		}
	}
}

END {
	# Print the list of best ordered words.
	for (i = 1; i <= best["count"]; i++)
		print best[i]
}
