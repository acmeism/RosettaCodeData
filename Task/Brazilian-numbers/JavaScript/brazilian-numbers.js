function sameDigits(n, b) {
    let f = n % b;
    while ((n = Math.floor(n / b)) > 0) {
        if (n % b !== f) {
            return false;
        }
    }
    return true;
}

function isBrazilian(n) {
    if (n < 7) return false;
    if (n % 2 === 0) return true;
    for (let b = 2; b < n - 1; b++) {
        if (sameDigits(n, b)) {
            return true;
        }
    }
    return false;
}

function isPrime(n) {
    if (n < 2) return false;
    if (n % 2 === 0) return n === 2;
    if (n % 3 === 0) return n === 3;
    let d = 5;
    while (d * d <= n) {
        if (n % d === 0) return false;
        d += 2;
        if (n % d === 0) return false;
        d += 4;
    }
    return true;
}

function main() {
    const kinds = ["", "odd ", "prime "];

    for (const kind of kinds) {
        let quiet = false;
        const BigLim = 99999;
        const limit = 20;
        console.log(`First ${limit} ${kind}Brazilian numbers:`);
        let c = 0;
        let n = 7;

        while (c < BigLim) {
            if (isBrazilian(n)) {
                if (!quiet) process.stdout.write(n + ' ');
                if (++c === limit) {
                    console.log("\n");
                    quiet = true;
                }
            }
            if (quiet && kind !== "") continue;

            if (kind === "") {
                n++;
            } else if (kind === "odd ") {
                n += 2;
            } else if (kind === "prime ") {
                while (true) {
                    n += 2;
                    if (isPrime(n)) break;
                }
            } else {
                throw new Error("Unexpected");
            }
        }

        if (kind === "") {
            console.log(`The ${BigLim + 1}th Brazilian number is: ${n}\n`);
        }
    }
}

main();
