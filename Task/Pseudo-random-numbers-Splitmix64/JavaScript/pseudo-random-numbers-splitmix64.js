class Splitmix64 {
  constructor(seed) {
    this.state = BigInt(seed);
    this.mask64 = (1n << 64n) - 1n;
  }

  next_int() {
    this.state = (this.state + 0x9e3779b97f4a7c15n) & this.mask64;
    let z = this.state;
    z = (z ^ (z >> 30n)) * 0xbf58476d1ce4e5b9n & this.mask64;
    z = (z ^ (z >> 27n)) * 0x94d049bb133111ebn & this.mask64;
    return z ^ (z >> 31n) & this.mask64;
  }

  next_float() {
    return Number(this.next_int()) / (2 ** 64);
  }
}

const random_gen = new Splitmix64(1234567);
for (let i = 0; i < 5; i++) {
  console.log(random_gen.next_int());
}

const random_gen2 = new Splitmix64(987654321);
let counts = Array(5).fill(0);
for (let i = 0; i < 100000; i++) {
	const res = Math.floor(random_gen2.next_float() * 5);
	counts[res]++;
}
console.log(counts);
