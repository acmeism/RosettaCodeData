fn main() {rows(5)}

fn rows(height int) [][]int {
	mut ret := [][]int{}
	mut cnum := 0
	for level := 1; level <= height; level++ {
		ret << []int{}
		cnum = 1
		for i := 1; i <= level; i++ {
			ret[level - 1] << cnum
			cnum = (cnum * (level - i)) / i
		}
		println(ret[level - 1])
	}
	return ret
}
