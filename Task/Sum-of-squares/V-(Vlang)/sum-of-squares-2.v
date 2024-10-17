import arrays

fn main() {
	a_list := [1, 2, 3, 4, 5]
	println(arrays.sum(a_list.map(it * it))!)
}
