class SetType {
    constructor() {
        this.items = [];
    }
}

function b2s(i, vars) {
    let s = "";
    for (let k = 0; k < vars; k++) {
        s = ((i & 1) ? "1" : "0") + s;
        i >>= 1;
    }
    return s;
}

function bitCount(s) {
    let count = 0;
    for (let i = 0; i < s.length; i++) {
        if (s[i] === '1') count++;
    }
    return count;
}

function merge(i, j) {
    const len = Math.min(i.length, j.length);
    let difCnt = 0;
    let s = "";
    for (let k = 0; k < len; k++) {
        const a = i[k], b = j[k];
        if (a === 'X' || b === 'X') {
            if (a !== b) {
                return "";
            }
            s += a;
        } else if (a !== b) {
            difCnt++;
            if (difCnt > 1) {
                return "";
            }
            s += 'X';
        } else {
            s += a;
        }
    }
    return s;
}

function addToSet(s, item) {
    for (const str of s.items) {
        if (str === item) {
            return;
        }
    }
    s.items.push(item);
}

function inSet(s, item) {
    for (const str of s.items) {
        if (str === item) {
            return true;
        }
    }
    return false;
}

function unionSets(dest, src) {
    for (const item of src.items) {
        addToSet(dest, item);
    }
}

function computePrimes(cubes, vars, primes) {
    const sigma = Array(vars + 1).fill().map(() => new SetType());
    let sigmaCount = 0;

    for (let j = 0; j <= vars; j++) {
        for (const cube of cubes.items) {
            if (bitCount(cube) === j) {
                addToSet(sigma[j], cube);
            }
        }
        if (sigma[j].items.length > 0) {
            sigmaCount = j + 1;
        }
    }

    primes.items = [];

    while (sigmaCount > 0) {
        const nsigma = Array(sigmaCount - 1).fill().map(() => new SetType());
        const redundant = new SetType();

        for (let i = 0; i < sigmaCount - 1; i++) {
            const c1 = sigma[i];
            const c2 = sigma[i + 1];
            const nc = new SetType();

            for (const a of c1.items) {
                for (const b of c2.items) {
                    const m = merge(a, b);
                    if (m !== "") {
                        addToSet(nc, m);
                        addToSet(redundant, a);
                        addToSet(redundant, b);
                    }
                }
            }
            nsigma[i] = nc;
        }

        for (let i = 0; i < sigmaCount; i++) {
            for (const cube of sigma[i].items) {
                if (!inSet(redundant, cube)) {
                    addToSet(primes, cube);
                }
            }
        }

        sigmaCount = nsigma.length;
        if (sigmaCount > 0) {
            sigma.length = sigmaCount;
            for (let i = 0; i < sigmaCount; i++) {
                sigma[i] = nsigma[i];
            }
        }
    }
}

function activePrimes(cubesel, primes, result) {
    result.items = [];
    const s = b2s(cubesel, primes.items.length);
    for (let i = 0; i < primes.items.length; i++) {
        if (s[i] === '1') {
            addToSet(result, primes.items[i]);
        }
    }
}

function isCover(prime, one) {
    const len = Math.min(prime.length, one.length);
    for (let i = 0; i < len; i++) {
        const p = prime[i], o = one[i];
        if (p !== 'X' && p !== o) {
            return false;
        }
    }
    return true;
}

function isFullCover(allPrimes, ones) {
    for (const one of ones.items) {
        let covered = false;
        for (const prime of allPrimes.items) {
            if (isCover(prime, one)) {
                covered = true;
                break;
            }
        }
        if (!covered) {
            return false;
        }
    }
    return true;
}

function unateCover(primes, ones, result) {
    let minCount = 1000;
    let minSel = -1;
    const active = new SetType();

    const total = (1 << primes.items.length);
    for (let cubesel = 0; cubesel < total; cubesel++) {
        activePrimes(cubesel, primes, active);
        if (isFullCover(active, ones)) {
            let cnt = 0;
            const binRep = b2s(cubesel, primes.items.length);
            for (let i = 0; i < binRep.length; i++) {
                if (binRep[i] === '1') cnt++;
            }
            if (cnt < minCount) {
                minCount = cnt;
                minSel = cubesel;
            }
        }
    }

    if (minSel !== -1) {
        activePrimes(minSel, primes, result);
    } else {
        result.items = [];
    }
}

function qm(ones, zeros, dc) {
    const result = new SetType();

    if (ones.length === 0 && zeros.length === 0 && dc.length === 0) {
        return result;
    }

    let maxVal = 0;
    for (const val of ones) if (val > maxVal) maxVal = val;
    for (const val of zeros) if (val > maxVal) maxVal = val;
    for (const val of dc) if (val > maxVal) maxVal = val;

    let numvars = 0;
    if (maxVal === 0) {
        numvars = 1;
    } else {
        let tmp = maxVal;
        while (tmp) {
            numvars++;
            tmp >>= 1;
        }
    }

    const onesSet = new SetType();
    const zerosSet = new SetType();
    const dcSet = new SetType();

    for (const val of ones) {
        addToSet(onesSet, b2s(val, numvars));
    }
    for (const val of zeros) {
        addToSet(zerosSet, b2s(val, numvars));
    }
    for (const val of dc) {
        addToSet(dcSet, b2s(val, numvars));
    }

    const cubes = new SetType();
    unionSets(cubes, onesSet);
    unionSets(cubes, dcSet);

    const primes = new SetType();
    computePrimes(cubes, numvars, primes);

    unateCover(primes, onesSet, result);
    return result;
}

// Example usage
function main() {
    const ones = [1, 2, 5];
    const zeros = [];
    const dc = [0, 7];

    const result = qm(ones, zeros, dc);

    console.log(result.items.join(" "));
}

main();
