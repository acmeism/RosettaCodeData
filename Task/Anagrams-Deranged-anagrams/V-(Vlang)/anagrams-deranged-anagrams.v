import os

fn deranged(a string, b string) bool {
	if a.len != b.len {
		return false
	}
	for i in 0..a.len {
		if a[i] == b[i] { return false }
	}
	return true
}
fn main(){
    words := os.read_lines('unixdict.txt')?

    mut m := map[string][]string{}
    mut best_len, mut w1, mut w2 := 0, '',''

    for w in words {
		// don't bother: too short to beat current record
		if w.len <= best_len { continue }

		// save strings in map, with sorted string as key
		mut letters := w.split('')
		letters.sort()
		k := letters.join("")

		if k !in m {
			m[k] = [w]
			continue
		}

		for c in m[k] {
			if deranged(w, c) {
				best_len, w1, w2 = w.len, c, w
				break
			}
		}

		m[k] << w
	}

	println('$w1 $w2: Length $best_len')
}
