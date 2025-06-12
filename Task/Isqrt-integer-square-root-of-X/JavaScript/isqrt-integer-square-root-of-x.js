function isqrt(x) {
    let q = 1n;
    while (q <= x) {
        q *= 4n;
    }

    let z = x;
    let r = 0n;

    while (q > 1) {
        q /= 4n;
        let t = z - r - q;
        r /= 2n;

        if (t >= 0) {
            z = t;
            r += q;
        }
    }
    return r;
}

const items = [];
for (let n = 0; n < 66; n++) {
    items.push(isqrt(BigInt(n)));
}

console.log(items.join(" "));

const items2 = [];

for (let n = 1n; n < 204n; n+= 2n) {
    items2.push(`${Intl.NumberFormat().format(isqrt(7n ** n))} = isqrt(7^${n})`);
}

console.log(items2.join('\n'));
