package cmp

func AllEqual(strings []string) bool {
	for _, s := range strings {
		if s != strings[0] {
			return false
		}
	}
	return true
}

func AllLessThan(strings []string) bool {
	for i := 1; i < len(strings); i++ {
		if !(strings[i - 1] < s) {
			return false
		}
	}
	return true
}
