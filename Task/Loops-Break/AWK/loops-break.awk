BEGIN {
	for (;;) {
		print n = int(rand() * 20)
		if (n == 10)
			break
		print int(rand() * 20)
	}
}
