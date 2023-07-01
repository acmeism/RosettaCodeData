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
		if (c ~ /[0-9A-Za-z]/)
		#if (c ~ /[-._*0-9A-Za-z]/)
			res = res c
		#else if (c == " ")
		#	res = res "+"
		else
			res = res "%" sprintf("%02X", ord[c])
	}
	return res
}

# Escape every line of input.
{ print escape($0) }
