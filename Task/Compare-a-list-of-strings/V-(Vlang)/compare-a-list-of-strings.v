fn all_equal(strings []string) bool {
	for s in strings {
		if s != strings[0] {
			return false
		}
	}
	return true
}

fn all_less_than(strings []string) bool {
	for i := 1; i < strings.len(); i++ {
		if !(strings[i - 1] < s) {
			return false
		}
	}
	return true
}
