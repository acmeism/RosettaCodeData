int main() {
	int limit = 1000;

	for(int i = 0; i < limit + 1; i++) {
			if(String.count((string)i, "1") == 2) {
				write((string)i + " ");
			}
		}
	write("\n");

	return 0;
}
