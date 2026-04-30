fn append_range(p_result string, first int, prev int, index int, size int) string {
	mut result := p_result
    if first == prev { result += "$prev" }
	else if first == prev - 1 { result += "$first,$prev"}
	else { result += "$first-$prev" }
    if index < size - 1 { result += "," }
    return result
}

fn extract_range(list []int) string {
    if list.len == 0 { return "" }
    mut result := ""
    mut first := list[0]
    mut prev := first
    for i := 1; i < list.len; i++ {
        if list[i] == prev + 1 { prev++ }
		else {
            result = append_range(result, first, prev, i, list.len)
            first = list[i]
            prev = first
        }
    }
    result = append_range(result, first, prev, list.len - 1, list.len)
    return result
}

fn main() {
    list1 := [-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]
    println(extract_range(list1))
    println("")
    list2 := [0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
              15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
              25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
              37, 38, 39]
    println(extract_range(list2))
}
