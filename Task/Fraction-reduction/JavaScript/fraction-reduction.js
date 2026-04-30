function indexOf(haystack, needle) {
    for (let i = 0; i < haystack.length; i++) {
        if (haystack[i] === needle) {
            return i;
        }
    }
    return -1;
}

function getDigits(n, le, digits) {
    while (n > 0) {
        const r = n % 10;
        if (r === 0 || indexOf(digits, r) >= 0) {
            return false;
        }
        le--;
        digits[le] = r;
        n = Math.floor(n / 10);
    }
    return true;
}

function removeDigit(digits, le, idx) {
    const pows = [1, 10, 100, 1000, 10000];
    let sum = 0;
    let pow = pows[le - 2];
    for (let i = 0; i < le; i++) {
        if (i === idx) continue;
        sum += digits[i] * pow;
        pow /= 10;
    }
    return sum;
}

function main() {
    const lims = [[12, 97], [123, 986], [1234, 9875], [12345, 98764]];
    const count = [0, 0, 0, 0, 0];
    const omitted = Array.from({ length: 5 }, () => new Array(10).fill(0));

    for (let i = 0; i < lims.length; i++) {
        const nDigits = new Array(i + 2).fill(0);
        const dDigits = new Array(i + 2).fill(0);
        for (let n = lims[i][0]; n <= lims[i][1]; n++) {
            nDigits.fill(0);
            const nOk = getDigits(n, i + 2, nDigits);
            if (!nOk) {
                continue;
            }
            for (let d = n + 1; d <= lims[i][1] + 1; d++) {
                dDigits.fill(0);
                const dOk = getDigits(d, i + 2, dDigits);
                if (!dOk) {
                    continue;
                }
                for (let nix = 0; nix < nDigits.length; nix++) {
                    const digit = nDigits[nix];
                    const dix = indexOf(dDigits, digit);
                    if (dix >= 0) {
                        const rn = removeDigit(nDigits, i + 2, nix);
                        const rd = removeDigit(dDigits, i + 2, dix);
                        if ((n / d) === (rn / rd)) {
                            count[i]++;
                            omitted[i][digit]++;
                            if (count[i] <= 12) {
                                console.log(`${n}/${d} = ${rn}/${rd} by omitting ${digit}'s`);
                            }
                        }
                    }
                }
            }
        }
        console.log();
    }

    for (let i = 2; i <= 5; i++) {
        console.log(`There are ${count[i - 2]} ${i}-digit fractions of which:`);
        for (let j = 1; j <= 9; j++) {
            if (omitted[i - 2][j] === 0) {
                continue;
            }
            console.log(`${omitted[i - 2][j].toString().padStart(6)} have ${j}'s omitted`);
        }
        console.log();
    }
}

main();
