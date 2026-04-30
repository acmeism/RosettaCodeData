const left_digits = {
		"   ## #": 0,
		"  ##  #": 1,
		"  #  ##": 2,
		" #### #": 3,
		" #   ##": 4,
		" ##   #": 5,
		" # ####": 6,
		" ### ##": 7,
		" ## ###": 8,
		"   # ##": 9,
	}
const end_sentinel = "# #"
const mid_sentinel = " # # "
const barcodes = [
		"         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
		"        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
		"         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
		"       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
		"         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
		"          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
		"         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
		"        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
		"         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
		"        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
	]

// right_digits by swapping "#" and " "
fn make_right_digits() map[string]int {
	mut right := map[string]int{}
	mut swapped := []rune{}
	for k, v in left_digits {
		swapped.clear() // clear array
		for ch in k.runes() {
			if ch == `#` { swapped << ` ` }
			else if ch == ` ` { swapped << `#` }
			else { swapped << ch }
		}
		right[swapped.string()] = v
	}
	return right
}

fn decode(candidate string, right_digits map[string]int) ?[]int {
	mut pos, mut sum := 0, 0
	mut output := []int{}
	mut part := candidate[pos..pos + end_sentinel.len]
	if candidate.len < end_sentinel.len { return none }
	if part != end_sentinel { return none }
	pos += end_sentinel.len
	for _ in 0 .. 6 {
		if pos + 7 > candidate.len { return none }
		part = candidate[pos..pos + 7]
		pos += 7
		val := left_digits[part] or { return none }
		output << val
	}
	if pos + mid_sentinel.len > candidate.len { return none }
	part = candidate[pos..pos + mid_sentinel.len]
	if part != mid_sentinel { return none }
	pos += mid_sentinel.len
	for _ in 0 .. 6 {
		if pos + 7 > candidate.len { return none }
		part = candidate[pos..pos + 7]
		pos += 7
		val := right_digits[part] or { return none }
		output << val
	}
	if pos + end_sentinel.len > candidate.len { return none }
	part = candidate[pos..pos + end_sentinel.len]
	if part != end_sentinel { return none }
	pos += end_sentinel.len
	// validation
	for i, d in output {
		if i % 2 == 0 { sum += d * 3 }
		else { sum += d }
	}
	if sum % 10 != 0 { return none }
	return output
}

fn decode_upc(input string) {
	right_digits := make_right_digits()
	candidate := input.trim_space()
	mut out := decode(candidate, right_digits)
	mut rev := candidate.runes().reverse().string()
	if out != none {
		println(out)
		return
	}
	// try reversed input
	out = decode(rev, right_digits)
	if out != none {
		println("${out} Upside down")
		return
	}
	// if decoding failed
	println("(bad barcode)")
}

fn main() {
	for barcode in barcodes {
		decode_upc(barcode)
	}
}
