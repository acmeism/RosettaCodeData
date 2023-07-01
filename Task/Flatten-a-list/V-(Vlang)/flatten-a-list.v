fn main() {
	arr := "[[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]"
	println(convert(arr))
}

fn convert(arr string) []int {
	mut new_arr := []int{}
	for value in arr.replace_each(["[","","]",""]).split_any(", ") {if value !="" {new_arr << value.int()}}
	return new_arr
}
