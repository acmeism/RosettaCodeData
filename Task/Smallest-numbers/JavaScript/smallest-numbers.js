function smallest_selfexp(n) {
	let k = 1n;
	while (!String(k ** k).match(String(n))) {
		k++;
	}	
	return `${n}: ${k}^${k} = ${k ** k}`;
}

for (let i = 0; i < 51; i++) {
	console.log(smallest_selfexp(i));
}
