function magic(n) {
	return n * (n ** 2 + 1) / 2;
}

for (let i = 3; i < 23; i++) {
	console.log(magic(i));
}

console.log(magic(1003));

function inv_magic(lower) {
	let n = 3;
	while (magic(n) <= lower) {
		n++;
	}
	return n;
}

for (let i = 1; i < 21; i++) {
	console.log(inv_magic(10 ** i));
}
