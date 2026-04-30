class Frac {
  constructor(num, den) {
    this.num = num;
    this.den = den;
  }

  toString() {
    return `${this.num}/${this.den}`;
  }

  valueOf() {
    return this.num / this.den;
  }
}

function genFarey(i) {
  const farey = new Set();
  const fracMap = new Map();

  for (let den = 1; den <= i; den++) {
    for (let num = 0; num <= den; num++) {
      const value = num / den;
      // Only add if this exact value hasn't been added yet
      if (!fracMap.has(value)) {
        const frac = new Frac(num, den);
        fracMap.set(value, frac);
        farey.add(frac);
      }
    }
  }

  // Sort fractions by their value
  return Array.from(farey).sort((a, b) => a.valueOf() - b.valueOf());
}

// Main execution
for (let i = 1; i <= 11; i++) {
  const farey = genFarey(i);
  console.log(`F${i}: [${farey.join(', ')}]`);
}

for (let i = 100; i <= 1000; i += 100) {
  console.log(`F${i}: ${genFarey(i).length} members`);
}
