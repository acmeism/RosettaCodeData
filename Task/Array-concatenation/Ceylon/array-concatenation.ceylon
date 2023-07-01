shared void arrayConcatenation() {
	value a = Array {1, 2, 3};
	value b = Array {4, 5, 6};
	value c = concatenate(a, b);
	print(c);
}
