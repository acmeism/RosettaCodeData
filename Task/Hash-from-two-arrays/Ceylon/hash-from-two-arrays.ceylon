shared void run() {
	value keys = [1, 2, 3];
	value items = ['a', 'b', 'c'];
	value hash = map(zipEntries(keys, items));
}
