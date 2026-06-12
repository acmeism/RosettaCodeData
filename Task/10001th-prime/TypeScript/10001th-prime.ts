function isPrime(n: number): boolean {
    if (n < 2) return false;
    if (n < 4) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (let i = 5; i <= n ** 0.5; i += 6) {
        if (n % i == 0 || n % (i+2) == 0) return false;
    }
    return true;
}

let count = 1;
let x = 1;

while (count < 10001) {
    x += 2;
    if (isPrime(x)) count++;
}

console.log(x);
