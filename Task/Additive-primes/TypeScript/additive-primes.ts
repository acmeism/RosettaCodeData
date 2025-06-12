function isPrime(n: number): boolean {
    if (n < 2) return false;
    if (n < 4) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (let i = 5; i <= n ** 0.5; i += 6) {
        if (n % i == 0 || n % (i+2) == 0) return false;
    }
    return true;
}

function sumDigits(x: number): number {
    let sum = 0;
    while (x > 0) {
      sum = sum + (x % 10);
      x = Math.floor(x / 10);
    }
    return sum;
}

const additivePrimes: number[] = [];

for (let i = 2; i < 10**7; i++) {
    if (isPrime(i) && isPrime(sumDigits(i))) {
        additivePrimes.push(i);
    }
}

console.log(additivePrimes);
console.log(`Found ${additivePrimes.length} values`);
