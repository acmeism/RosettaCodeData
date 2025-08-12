const nMax = 12;

let superperm;
let pos;
let count = new Array(nMax);

function factSum(n) {
    let sum = 0;
    for (let m = 1; m <= n; m++) {
        let factorial = 1;
        for (let i = 1; i <= m; i++) {
            factorial *= i;
        }
        sum += factorial;
    }
    return sum;
}

function r(n) {
    if (n === 0) {
        return false;
    }

    const c = superperm[pos - n];
    if (--count[n] === 0) {
        count[n] = n;
        if (!r(n - 1)) {
            return false;
        }
    }
    superperm[pos++] = c;
    return true;
}

function superPerm(n) {
    const chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    pos = n;
    superperm = new Array(factSum(n));

    for (let i = 0; i < n + 1; i++) {
        count[i] = i;
    }
    for (let i = 1; i < n + 1; i++) {
        superperm[i - 1] = chars.charAt(i);
    }

    while (r(n)) {
        // Continue until r(n) returns false
    }
}

function main() {
    for (let n = 0; n < nMax; n++) {
        superPerm(n);
        console.log(`superPerm(${n.toString().padStart(2, ' ')}) len = ${superperm.length}`);
    }
}

// Run the main function
main();
