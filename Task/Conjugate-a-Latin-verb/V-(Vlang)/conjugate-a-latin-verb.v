import log

const (
	endings = [
		["o", "as", "at", "amus", "atis", "ant"],
		["eo", "es", "et", "emus", "etis", "ent"],
		["o", "is", "it", "imus", "itis", "unt"],
		["io", "is", "it", "imus", "itis", "iunt"]
	]
	infin_endings = ["are", "ēre", "ere", "ire"]
	pronouns = ["I", "you (singular)", "he, she or it", "we", "you (plural)", "they"]
	english_endings = ["", "", "s", "", "", ""]
)

fn main() {
	pairs := [["amare", "love"], ["vidēre", "see"], ["ducere", "lead"], ["audire", "hear"]] // error check
	for _, pair in pairs {
		conjugate(pair[0], pair[1])
	}
}

fn conjugate(infinitive string, english string) {
	letters := infinitive.runes()
	le := letters.len
	mut lg := log.Log{}
	mut infin_ending, mut stem := '', ''
	mut conj := 0
	lg.set_level(.error)
	lg.set_full_logpath('./info.log')
	if le < 4 {
		lg.error("Infinitive (${letters.string()}) is too short for a regular verb.")
		exit(1)
	}
	infin_ending = letters[le - 3..].string()
	conj = -1
	for i, s in infin_endings {
		if s == infin_ending {
			conj = i
			break
		}
	}
	if conj == -1 {
		lg.error("Infinitive ending -${infin_ending} not recognized.")
		exit(1)
	}
	stem = letters[..le - 3].string()
	print("Present indicative tense, active voice, of ${infinitive} to '${english}':\n")
	for i, ending in endings[conj] {
		print("	${stem}${ending}  ${pronouns[i]} ${english}${english_endings[i]}\n")
	}
	println('')
}
