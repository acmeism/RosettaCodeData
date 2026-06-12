struct Column {
	mut:
	row [13]bool
}

fn punch(i int, j int, mut card []Column) {
	card[i].row[j] = true
}

fn punch_card(text string) {
	mut card := []Column{len: 81}
	for i := 0; i < 81; i++ {
		card[i] = Column{}
	}
	if text.len > 80 {
		println('Error: Too many columns')
		exit(1)
	}
	for i, c in text {
		pos := i + 1
		code := int(c)
		match c {
			`&` { punch(pos, 12, mut card)
			}
			`A`...`I` {
				punch(pos, 12, mut card)
				punch(pos, code - int(`A`) + 1, mut card)
			}
			`[` {
				punch(pos, 2, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`.` {
				punch(pos, 3, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`<` {
				punch(pos, 4, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`(` {
				punch(pos, 5, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`+` {
				punch(pos, 6, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`!` {
				punch(pos, 7, mut card)
				punch(pos, 8, mut card)
				punch(pos, 12, mut card)
			}
			`-` {
				punch(pos, 11, mut card)
			}
			`J`...`R` {
				punch(pos, 11, mut card)
				punch(pos, code - int(`J`) + 1, mut card)
			}
			`]` {
				punch(pos, 2, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`$` {
				punch(pos, 3, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`*` {
				punch(pos, 4, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`)` {
				punch(pos, 5, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`;` {
				punch(pos, 6, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`^` {
				punch(pos, 7, mut card)
				punch(pos, 8, mut card)
				punch(pos, 11, mut card)
			}
			`/` {
				punch(pos, 0, mut card)
				punch(pos, 1, mut card)
			}
			`S`...`Z` {
				punch(pos, 0, mut card)
				punch(pos, code - int(`S`) + 2, mut card)
			}
			`\\` {
				punch(pos, 2, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			`,` {
				punch(pos, 3, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			`%` {
				punch(pos, 4, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			`_` {
				punch(pos, 5, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			`>` {
				punch(pos, 6, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			`?` {
				punch(pos, 7, mut card)
				punch(pos, 8, mut card)
				punch(pos, 0, mut card)
			}
			` ` {
				// do nothing
			}
			`0`...`9` {
				punch(pos, code - int(`0`), mut card)
			}
			`\`` {
				punch(pos, 1, mut card)
				punch(pos, 8, mut card)
			}
			`:` {
				punch(pos, 2, mut card)
				punch(pos, 8, mut card)
			}
			`#` {
				punch(pos, 3, mut card)
				punch(pos, 8, mut card)
			}
			`@` {
				punch(pos, 4, mut card)
				punch(pos, 8, mut card)
			}
			`'` {
				punch(pos, 5, mut card)
				punch(pos, 8, mut card)
			}
			`=` {
				punch(pos, 6, mut card)
				punch(pos, 8, mut card)
			}
			`"` {
				punch(pos, 7, mut card)
				punch(pos, 8, mut card)
			}
			`a`...`i` {
				punch(pos, 12, mut card)
				punch(pos, 0, mut card)
				punch(pos, code - int(`a`) + 1, mut card)
			}
			`|` {
				punch(pos, 12, mut card)
				punch(pos, 11, mut card)
			}
			`j`...`r` {
				punch(pos, 12, mut card)
				punch(pos, 11, mut card)
				punch(pos, code - int(`j`) + 1, mut card)
			}
			`s`...`z` {
				punch(pos, 11, mut card)
				punch(pos, 0, mut card)
				punch(pos, code - int(`s`) + 2, mut card)
			}
			else {
				println("Invalid code: ${c}")
				exit(1)
			}
		}
	}
	println(" " + "_".repeat(80) + ".")
	print("/")
	for i := 1; i <= 80; i++ {
		if card[i].row[12] { print("x") }
		else { print(" ") }
	}
	println("|")
	print("|")
	for i := 1; i <= 80; i++ {
		if card[i].row[11] { print("x") }
		else { print(" ") }
	}
	println("|")
	for j := 0; j <= 9; j++ {
		print("|")
		for i := 1; i <= 80; i++ {
			if card[i].row[j] { print("x") }
			else { print(" ") }
		}
		println("|")
	}
	println("|" + "_".repeat(80) + "|")
}

fn main() {
	punch_card("&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=\"[.<(+|]$*);^\\,%_>?")
	println("Hello World!")
	punch_card("with Ada.Text_IO;  use Ada.Text_IO;")
	punch_card("procedure Hello is")
	punch_card("begin")
	punch_card("   Put_Line (\"Hello World!\");")
	punch_card("end Hello;")
}
