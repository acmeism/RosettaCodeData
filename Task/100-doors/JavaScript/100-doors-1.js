var doors = [], n = 100, i, j;

for (i = 1; i <= n; i++) {
	for (j = i; j <= n; j += i) {
		doors[j] = !doors[j];
	}
}

for (i = 1 ; i <= n ; i++) {
	if (doors[i]) console.log("Door " + i + " is open");
}
