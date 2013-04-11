BEGIN {
	for (i = 0; i <= 255; i++)
		ord[sprintf("%c", i)] = i
}

# Encode string with application/x-www-form-urlencoded escapes.
function escape(str,    c, len, res) {
	len = length(str)
	res = ""
	for (i = 1; i <= len; i++) {
		c = substr(str, i, 1);
		if (c ~ /[-._*0-9A-Za-z]/)
			res = res c
		else if (c == " ")
			res = res "+"
		else
			res = res "%" sprintf("%02X", ord[c])
	}
	return res
}

function nc_open(gcmcontinue,    host, path) {
	host = "rosettacode.org"
	path = "/mw/api.php" \
	    "?action=query" \
	    "&generator=categorymembers" \
	    "&gcmtitle=Category:Programming%20Languages" \
	    "&gcmlimit=500" \
	    (gcmcontinue "" ? "&gcmcontinue=" escape(gcmcontinue) : "") \
	    "&prop=categoryinfo" \
	    "&format=txt"

	nc = "printf 'GET %s HTTP/1.1\r\nHost: %s\r\n\r\n' '" \
	    path "' '" host "' | nc '" host "' 80"
}

function nc_next(out) {
	# Read each line of the HTTP response.
	while (nc | getline > 0) {
		# Ignore all lines except
		# [gcmcontinue], [title] and [pages].
		if (index($0, "[gcmcontinue]")) {
			# "  [gcmcontinue] => BEFUNGE|"
			sub(/^.*=> */, "")
			out["gcmcontinue"] = $0
		} else if (index($0, "[title]")) {
			# "  [title] => Category:AWK"
			sub(/^.*Category:/, "")
			out["title"] = $0
		} else if(index($0, "[pages]")) {
			# "  [pages] => 129"
			sub(/^.*=> */, "")
			# Ignore "  [pages] => Array".
			if ($0 !~ /^[0-9]+/)
				continue

			# Force conversion to number, so AWK will do
			# numeric comparisons, not string comparisons.
			out["pages"] = $0 + 0

			# Return now; [pages] came after [title].
			return 1
		}
	}

	if ("gcmcontinue" in out) {
		close(nc)
		nc_open(out["gcmcontinue"])
		delete out["gcmcontinue"]
		return nc_next(out)
	} else
		return 0
}

BEGIN {
	nc_open()
	while (nc_next(language)) {
		title = language["title"]	# "AWK"
		pages = language["pages"]	# 129

		# Insert "129 - AWK" into rank[].
		i = 1
		while (i <= count && (rank[i] + 0) >= pages)
			i++
		for (j = count; j >= i; j--)
			rank[j + 1] = rank[j]
		rank[i] = pages " - " title
		count++
	}

	for (i = 1; i <= count; i++)
		print i ". " rank[i]
}
