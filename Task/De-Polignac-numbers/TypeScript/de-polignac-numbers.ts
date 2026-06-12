function isPrime(n: number): boolean {
    if (n < 2) return false;
    if (n < 4) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (let i = 5; i <= n ** 0.5; i += 6) {
        if (n % i == 0 || n % (i+2) == 0) return false;
    }
    return true;
}

function isDePolignac(x: number): boolean {
    if (x % 2 == 0) return false;
    for (let p = 1; p < x; p *= 2) {
        if (isPrime(x - p))
            return false;
    }
    return true;
}

let count = 0;
let val = 0;
const list: number[] = [];
while (count < 10000) {
    val += 1;
    if (isDePolignac(val)) {
        count += 1;
        if (count <= 50) list.push(val);
        if (count == 50) console.log(list);
        if (count == 1000 || count == 10000) {
            console.log("The " + count + "th De Polignac number is " + val);
        }
    }
}
