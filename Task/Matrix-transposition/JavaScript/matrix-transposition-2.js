transpose = function(a) {
	return a[0].map(function(x,i) {
		return a.map(function(y,k) {
			return y[i];
		});
	});
}

A = [[1,2,3],[4,5,6],[7,8,9],[10,11,12]];

JSON.stringify(transpose(A));
"[[1,4,7,10],[2,5,8,11],[3,6,9,12]]"
