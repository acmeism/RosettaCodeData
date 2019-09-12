class ZigZag(Integer size) {
	
	value data = Array {
		for (i in 0:size)
		Array.ofSize(size, 0)
	};
	
	variable value i = 1;
	variable value j = 1;
	
	for (element in 0 : size^2) {
		data[j - 1]?.set(i - 1, element);
		if ((i + j).even) {
			if (j < size) {
				j++;
			}
			else {
				i += 2;
			}
			if (i > 1) {
				i--;
			}
		}
		else {
			if (i < size) {
				i++;
			}
			else {
				j += 2;
			}
			if (j > 1) {
				j--;
			}
		}
	}
	
	shared void display() {
		for (row in data) {
			for (element in row) {
				process.write(element.string.pad(3));
			}
			print(""); //newline
		}
	}
}

shared void run() {
	value zz = ZigZag(5);
	zz.display();
}
