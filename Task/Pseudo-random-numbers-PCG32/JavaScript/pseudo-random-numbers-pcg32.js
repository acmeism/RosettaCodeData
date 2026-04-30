class PCG32 {
  constructor(seed_state, seed_sequence) {
    this.N = 6364136223846793005n;
    this.mask64 = (1n << 64n) - 1n;
    this.mask32 = (1n << 32n) - 1n;
    this.inc = BigInt(seed_sequence) << 1n | 1n & this.mask64;
    this.state = (this.inc + this.N * (this.inc + BigInt(seed_state))) & this.mask64;
  }

  next_int() {
    const xs = (this.state >> 18n ^ this.state) >> 27n & this.mask32;
    const rot = this.state >> 59n;
    this.state = (this.inc + this.N * this.state) & this.mask64;
    return Number(((xs >> rot) | (xs << (-rot & 31n))) & this.mask32);
  }

  next_float() {
    return this.next_int() / (2 ** 32);
  }
}

const random_gen = new PCG32(42, 54);
for (let i = 0; i < 5; i++) {
  console.log(random_gen.next_int());
}

const random_gen2 = new PCG32(987654321, 1);
let counts = Array(5).fill(0);
for (let i = 0; i < 100000; i++) {
	const res = Math.floor(random_gen2.next_float() * 5);
	counts[res]++;
}
console.log(counts);
