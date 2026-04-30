function compositeNumbersK() {
    let k = 11 * 11;
    const result = [];

    while (result.length < 20) {
        while (k % 3 === 0 || k % 5 === 0 || k % 7 === 0) {
            k += 2;
        }

        const factors = primeFactors(k);
        if (factors.length > 1) {
            const stringK = String(k);
            if (factors.every(factor => stringK.includes(String(factor)))) {
                result.push(k);
            }
        }
        k += 2;
    }

    let output = '';
    for (let i = 0; i < result.length; i++) {
        output += String(result[i]).padStart(10, ' ');
        if (i === 9 || i === 19) {
            output += '\n';
        }
    }
    console.log(output);
    return result;
}

function primeFactors(k) {
    const result = [];
    if (k <= 1) {
        return result;
    }

    if (isProbablePrime(k, 10)) {
        result.push(k);
        return result;
    }

    const divisor = pollardsRho(k);
    result.push(...primeFactors(divisor));
    result.push(...primeFactors(Math.floor(k / divisor)));
    result.sort((a, b) => a - b);
    return result;
}

function pollardsRho(n) {
    const bigN = BigInt(n);

    if (bigN % 2n === 0n) {
        return 2;
    }

    const bitLength = bigN.toString(2).length;
    const constant = randomBigInt(bitLength) % bigN;
    let x = randomBigInt(bitLength) % bigN;
    let xx = x;
    let divisor = 1n;

    while (divisor === 1n) {
        x = (x * x % bigN + constant) % bigN;
        xx = (xx * xx % bigN + constant) % bigN;
        xx = (xx * xx % bigN + constant) % bigN;
        divisor = gcd(x > xx ? x - xx : xx - x, bigN);
    }

    return Number(divisor);
}

function gcd(a, b) {
    a = typeof a === 'bigint' ? a : BigInt(a);
    b = typeof b === 'bigint' ? b : BigInt(b);

    while (b !== 0n) {
        const temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

function isProbablePrime(n, certainty) {
    if (n < 2) return false;
    if (n === 2 || n === 3) return true;
    if (n % 2 === 0) return false;

    // Miller-Rabin primality test
    let d = n - 1;
    let r = 0;
    while (d % 2 === 0) {
        d = Math.floor(d / 2);
        r++;
    }

    for (let i = 0; i < certainty; i++) {
        const a = 2 + Math.floor(Math.random() * (n - 3));
        let x = modPow(a, d, n);

        if (x === 1 || x === n - 1) continue;

        let continueOuter = false;
        for (let j = 0; j < r - 1; j++) {
            x = modPow(x, 2, n);
            if (x === n - 1) {
                continueOuter = true;
                break;
            }
        }

        if (!continueOuter) return false;
    }

    return true;
}

function modPow(base, exp, mod) {
    let result = 1;
    base = base % mod;
    while (exp > 0) {
        if (exp % 2 === 1) {
            result = (result * base) % mod;
        }
        exp = Math.floor(exp / 2);
        base = (base * base) % mod;
    }
    return result;
}

function randomBigInt(bitLength) {
    const bytes = Math.ceil(bitLength / 8);
    let result = 0n;
    for (let i = 0; i < bytes; i++) {
        result = (result << 8n) | BigInt(Math.floor(Math.random() * 256));
    }
    return result;
}

// Run the main function
compositeNumbersK();
