#!/usr/bin/env nodejs
function ack(M, N){
	const next = new Float64Array(M + 1);
	const goal = new Float64Array(M + 1).fill(1, 0, M);
	const n = N + 1;

	// This serves as a sentinel value;
	// next[M] never equals goal[M] == -1,
	// so we don't need an extra check for
	// loop termination below.
	goal[M] = -1;

	let v;
	do {
		v = next[0] + 1;
		let m = 0;
		while (next[m] === goal[m]) {
			goal[m] = v;
			next[m++]++;
		}
		next[m]++;
	} while (next[M] !== n);
	return v;
}
var args = process.argv;
console.log(ack(parseInt(args[2]), parseInt(args[3])));
