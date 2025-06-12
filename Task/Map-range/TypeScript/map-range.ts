function mapRange(
	a: number[],
	b: number[],
	s: number
): number {
	return b[0] + (s-a[0]) * (b[1]-b[0]) / (a[1]-a[0]);
}

const a = [0, 10];
const b = [-1, 0];

for (let s = 0; s < 11; s++) {
	console.log(`${s} -> ${mapRange(a, b, s)}`);
}
