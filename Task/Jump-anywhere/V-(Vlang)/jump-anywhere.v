// Unsafe 'goto' pseudo example:

if x {
	// ...
	if y {
		unsafe {
			goto my_label
		}
	}
	// ...
}
my_label:

// Labelled 'break' and 'continue' example:

outer:
for idx := 0; idx < 4; idx++ {
	for jdx := 0; jdx < 4; jdx++ {
		if idx + jdx == 4 {continue outer}
		if idx + jdx == 5 {break outer}
		println(idx + jdx)
	}
}
