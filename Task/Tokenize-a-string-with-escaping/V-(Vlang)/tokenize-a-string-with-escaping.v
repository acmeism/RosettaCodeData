fn tokenize_string(s string, sep u8, escape u8) ?[]string {
    mut tokens := []string{}
	mut runes := []u8{}
	mut in_escape := false
	for r in s {
		if in_escape {
			in_escape = false
		    runes << r
        } else if r == escape {
			in_escape = true
        } else if r == sep {
			tokens << runes.bytestr()
			runes = runes[..0]
		} else {
            runes << r
        }
	}
	tokens << runes.bytestr()
	if in_escape {
		return error("invalid terminal escape")
	}
	return tokens
}

const sample = "one^|uno||three^^^^|four^^^|^cuatro|"
const separator = `|`
const escape = `^`
fn main() {
	println("Input:   $sample")
	tokens := tokenize_string(sample, separator, escape)?
	println("Tokens: $tokens")
}
