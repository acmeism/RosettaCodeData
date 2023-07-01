package main
import "fmt"

func amb(wordsets [][]string, res []string) bool {
	if len(wordsets) == 0 {
		return true
	}

	var s string

	l := len(res)
	if l > 0 { s = res[l - 1] }

	res = res[0:len(res) + 1]

	for _, res[l] = range(wordsets[0]) {
		if l > 0 && s[len(s) - 1] != res[l][0] { continue }

		if amb(wordsets[1:len(wordsets)], res) {
			return true
		}
	}

	return false
}

func main() {
	wordset := [][]string { { "the", "that", "a" },
				{ "frog", "elephant", "thing" },
				{ "walked", "treaded", "grows" },
				{ "slowly", "quickly" } }
	res := make([]string, len(wordset))

	if amb(wordset, res[0:0]) {
		fmt.Println(res)
	} else {
		fmt.Println("No amb found")
	}
}
