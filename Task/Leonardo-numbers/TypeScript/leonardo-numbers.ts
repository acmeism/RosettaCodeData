function leoNums(
	n: number,
	L0: number = 1,
	L1: number = 1,
	add: number = 1
): number[] {
	const lNums: number[] = [L0, L1];
	while (lNums.length < n) {
		lNums.push(lNums[lNums.length - 1] + lNums[lNums.length - 2] + add);
	}
	return lNums
}

console.log(leoNums(25))
console.log(leoNums(25, 0, 1, 0))
