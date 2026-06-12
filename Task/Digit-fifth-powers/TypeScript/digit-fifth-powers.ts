function sumFifthPowers(x: number): number {
    let sum = 0;
    while (x > 0) {
      sum = (sum + (x % 10) ** 5);
      x = Math.floor(x / 10);
    }
    return sum;
}

let result = 0;
const limit = 9**5 * 6;
for (let i = 2; i < limit; i++) {
    if (i == sumFifthPowers(i)) {
        result += i;
    }
}

console.log(result);
