function smallest_six(n) {
	let p = 1n;
	let lg = 0;
	while (!String(p).match(String(n))) {
		p = 6n * p;
		lg++;
	}
	return `${n}: 6^${lg} = ${p}`;
}

for(let i = 0; i < 22; i++) {
	console.log(smallest_six(i));
}
