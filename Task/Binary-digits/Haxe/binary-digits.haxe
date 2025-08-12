class Main {
	static public function main() {
		var integers = [5, 50, 9000];

		for (i in integers) {
			var bin = "";
			while (i > 1) {
				bin = (i % 2) + bin;
				i = Std.int(i / 2);
			}
			bin = i + bin;
			trace(bin);
		}
	}
}
