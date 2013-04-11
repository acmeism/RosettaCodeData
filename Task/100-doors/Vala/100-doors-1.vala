int main() {
	bool doors_open[101];
	for(int i = 1; i < doors_open.length; i++) {
		for(int j = 1; i*j < doors_open.length; j++) {
			doors_open[i*j] = !doors_open[i*j];
		}
		stdout.printf("%d: %s\n", i, (doors_open[i] ? "open" : "closed"));
	}
	return 0;
}
