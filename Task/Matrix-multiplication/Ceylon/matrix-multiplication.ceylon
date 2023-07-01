alias Matrix => Integer[][];

void printMatrix(Matrix m) {
	value strings = m.collect((row) => row.collect(Integer.string));
	value maxLength = max(expand(strings).map(String.size)) else 0;
	value padded = strings.collect((row) => row.collect((s) => s.padLeading(maxLength)));
	for (row in padded) {
		print("[``", ".join(row)``]");
	}
}

Matrix? multiplyMatrices(Matrix a, Matrix b) {
	
	function rectangular(Matrix m) =>
			if (exists firstRow = m.first)
			then m.every((row) => row.size == firstRow.size)
			else false;
	
	function rowCount(Matrix m) => m.size;
	function columnCount(Matrix m) => m[0]?.size else 0;
	
	if (!rectangular(a) || !rectangular(b) || columnCount(a) != rowCount(b)) {
		return null;
	}
	
	function getNumber(Matrix m, Integer x, Integer y) {
		assert (exists number = m[y]?.get(x));
		return number;
	}
	
	function getRow(Matrix m, Integer rowIndex) {
		assert (exists row = m[rowIndex]);
		return row;
	}
	
	function getColumn(Matrix m, Integer columnIndex) => {
		for (y in 0:rowCount(m))
		getNumber(m, columnIndex, y)
	};
	
	return [
		for (y in 0:rowCount(a)) [
			for (x in 0:columnCount(b))
			sum { 0, for ([a1, b1] in zipPairs(getRow(a, y), getColumn(b, x))) a1 * b1 }
		]
	];
}

shared void run() {
    value m = [[1, 2, 3], [4, 5, 6]];
    printMatrix(m);
    print("---------");
    print("multiplied by");
    value m2 = [[7, 8], [9, 10], [11, 12]];
    printMatrix(m2);
    print("---------");
    print("equals:");
    value result = multiplyMatrices(m, m2);
    if (exists result) {
        printMatrix(result);
    }
    else {
        print("something went wrong!");
    }
}
