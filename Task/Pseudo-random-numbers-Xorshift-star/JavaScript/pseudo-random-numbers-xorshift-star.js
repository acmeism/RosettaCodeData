class Xorshift_star {
	constructor(seed) {
		this.state = BigInt(seed);
		this.k = 0x2545F4914F6CDD1Dn;
		this.mask64 = (1n << 64n) - 1n;
		this.mask32 = (1n << 32n) - 1n;
	}
	
	next_int() {
		let x = this.state & this.mask64;
		x = x ^ (x >> 12n) & this.mask64;
		x = x ^ (x << 25n) & this.mask64;
		x = x ^ (x >> 27n) & this.mask64;
		this.state = x;
		return Number((x * this.k) >> 32n & this.mask32);
	}
	
	next_float() {
		return this.next_int() / (2 ** 32);
	}
}

const random_gen = new Xorshift_star(1234567);
for (let i = 0; i < 5; i++) {
	console.log(random_gen.next_int());
}

const random_gen2 = new Xorshift_star(987654321);
let counts = Array(5).fill(0);
for (let i = 0; i < 100000; i++) {
	const res = Math.floor(random_gen2.next_float() * 5);
	counts[res]++;
}
console.log(counts);
