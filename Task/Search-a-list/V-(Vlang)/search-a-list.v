const (
	haystacks = ["Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Bozo"]
	needles = ["Bush", "washington", "Wally"]
)

fn main() {
	mut list, mut index, mut count, mut missing := "", "", "", ""
	for nee in needles {
		for idx, hay in haystacks {
			if nee == hay {
				count = "${haystacks.str().count(nee)}"
				if list.contains(nee) {
					index += ", ${idx}"
					list = "Found: ${nee}; Index: ${index}; Count: ${count}\n"
				}
				else {
					index = "${idx}"
					list += "Found: ${nee}; Index: ${index}; Count: ${count}\n"
				}
			}
		}
		if nee !in haystacks && !missing.contains(nee) {missing += "Missing: ${nee}\n"}
	}
	list += missing
	println(list.all_before_last('\n'))
}
