import arrays

struct PalFinder {
    mut:
    str string
    pal []string
}

fn (mut pf PalFinder) is_palindrome(word string) bool {
	if word == word.runes().reverse().string() { return true }
	return false
}

fn (mut pf PalFinder) process_palindromes() {
    for nir := 0; nir < pf.str.len; nir++ {
        for mir := 1; mir <= pf.str.len - nir; mir++ {
            str_pal := pf.str.substr_ni(nir, mir)
            if pf.is_palindrome(str_pal) && str_pal !="" { pf.pal << str_pal }
        }
    }
    pf.pal = arrays.uniq[string](pf.pal.sorted())
}

fn main() {
    mut pf := PalFinder{}
    pf.str = "eertree"
    pf.process_palindromes()
    println("Processing string: '${pf.str}'")
    println("Number of sub-palindromes: ${pf.pal.len}")
    println("Sub-palindromes: ${pf.pal}")
}
