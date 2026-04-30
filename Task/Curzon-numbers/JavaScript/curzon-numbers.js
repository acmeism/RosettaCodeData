/**
 * Curzon Numbers
 *
 * A generalized Curzon number is a positive integer n such that:
 * k^n + 1 is divisible by (k * n + 1)
 * For k = 2, this gives the classic definition of Curzon numbers
 */

function isGeneralisedCurzonNumber(aK, aN) {
    const r = aK * aN;
    return modulusPower(aK, aN, r + 1) === r;
}

function modulusPower(aBase, aExponent, aModulus) {
    if (aModulus === 1) {
        return 0;
    }

    aBase %= aModulus;
    let result = 1;
    while (aExponent > 0) {
        if ((aExponent & 1) === 1) {
            result = (result * aBase) % aModulus;
        }
        aBase = (aBase * aBase) % aModulus;
        aExponent >>= 1;
    }
    return result;
}

function main() {
    for (let k = 2; k <= 10; k += 2) {
        console.log(`Generalised Curzon numbers with base ${k}:`);

        let n = 1;
        let count = 0;
        const results = [];

        // Find the first 50 Curzon numbers
        while (count < 50) {
            if (isGeneralisedCurzonNumber(k, n)) {
                results.push(n);
                count++;
            }
            n++;
        }

        // Print in rows of 10
        for (let i = 0; i < results.length; i++) {
            const lineEnd = (i + 1) % 10 === 0 ? '\n' : ' ';
            process.stdout.write(`${results[i].toString().padStart(4)}${lineEnd}`);
        }

        // Reset and find the 1000th Curzon number
        count = 0;
        while (count < 1000) {
            if (isGeneralisedCurzonNumber(k, n)) {
                count++;
            }
            n++;
        }

        console.log(`1,000th Generalised Curzon number with base ${k}: ${n - 1}`);
        console.log();
    }
}

main();
