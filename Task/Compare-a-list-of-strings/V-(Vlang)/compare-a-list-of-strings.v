fn all_equal(strings []string) bool {
	for s in strings {
		if s != strings[0] {
			return false
		}
	}
	return true
}

fn all_less_than(strings []string) bool {
	for i := 1; i < strings.len; i++ {
		if strings[i - 1] >= strings[i] {
			return false
		}
	}
	return true
}

fn main() {
    a := ['a', 'a', 'a']
    b := ['a', 'b', 'c']
    c := ['a', 'a', 'b']
    d := ['a', 'd', 'c']
    println('${a} are all equal : ${all_equal(a)}')
    println('${b} are ascending : ${all_less_than(b)}')
    println('${c} are all equal : ${all_equal(c)}')
    println('${d} are ascending : ${all_less_than(d)}')
}
