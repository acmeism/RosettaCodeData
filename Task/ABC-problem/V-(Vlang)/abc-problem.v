const
(
	blocks = ["BO","XK","DQ","CP","NA","GT","RE","TG","QD","FS","JW","HU","VI","AN","OB","ER","FS","LY","PC","ZM"]
	words = ["A", BARK","BOOK","TREAT","COMMON","SQUAD","CONFUSE"]
)

fn main() {
	for word in words {
		println('>>> can_make_word("${word.to_upper()}"): ')
		if check_word(word, blocks) == true {println('True')} else {println('False')}
	}
}

fn check_word(word string, blocks []string) bool {
	mut tblocks := blocks.clone()
	mut found := false
	for chr in word {
		found = false
		for idx, _ in tblocks {
			if tblocks[idx].contains(chr.ascii_str()) == true {
				tblocks[idx] =''
				found = true
				break
			}
		}
		if found == false {return found}
	}
	return found
}
