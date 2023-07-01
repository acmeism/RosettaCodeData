const cholesky = function (array) {
	const zeros = [...Array(array.length)].map( _ => Array(array.length).fill(0));
	const L = zeros.map((row, r, xL) => row.map((v, c) => {
		const sum = row.reduce((s, _, i) => i < c ? s + xL[r][i] * xL[c][i] : s, 0);
		return xL[r][c] = c < r + 1 ? r === c ? Math.sqrt(array[r][r] - sum) : (array[r][c] - sum) / xL[c][c] : v;
	}));
	return L;
}

let arr3 = [[25, 15, -5], [15, 18, 0], [-5, 0, 11]];
console.log(cholesky(arr3));
let arr4 = [[18, 22, 54, 42], [22, 70, 86, 62], [54, 86, 174, 134], [42, 62, 134, 106]];
console.log(cholesky(arr4));
