int main (string[] args) {
	if (args.length < 2) {
		print ("Please, input an integer > 0.\n");
		return 0;
	}
	var n = int.parse (args[1]);
	if (n <= 0) {
		print ("Please, input an integer > 0.\n");
		return 0;
	}
	int[,] array = new int[n, n];
	for (var i = 0; i < n; i ++) {
		for (var j = 0; j < n; j ++) {
			if (i == j) array[i,j] = 1;
			else array[i,j] = 0;
		}
	}
	for (var i = 0; i < n; i ++) {
		for (var j = 0; j < n; j ++) {
			print ("%d ", array[i,j]);
		}
		print ("\b\n");
	}
	return 0;
}
