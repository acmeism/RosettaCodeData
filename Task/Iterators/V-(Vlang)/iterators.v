struct Iterator {
	arr []int
	mut:
	idx int
}

// method for above struct, to be use for custom interator
fn (mut iter Iterator) next() ?int {
	if iter.idx >= iter.arr.len {return none}
	defer {iter.idx++}
	return iter.arr[iter.idx] * iter.arr[iter.idx]
}

fn main() {
	nums := [1, 2, 3, 4, 5]
	iter := Iterator{arr: nums}
	for squared in iter {
		println(squared)
	}
}
