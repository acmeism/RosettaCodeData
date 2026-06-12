function CumulativeFreq(freq) {
    let total = 0;
    const cf = new Map();
    for (let i = 0; i < 256; i++) {
        const c = String.fromCharCode(i);
        if (freq.has(c)) {
            const v = freq.get(c);
            cf.set(c, total);
            total += v;
        }
    }
    return cf;
}

function ArithmeticCoding(str, radix) {
    const freq = new Map();
    for (let i = 0; i < str.length; i++) {
        const c = str[i].toString();
        if (freq.has(c)) freq.set(c, freq.get(c) + 1);
        else freq.set(c, 1);
    }
    const cf = CumulativeFreq(freq);
    const base = BigInt(str.length);
    let lower = BigInt(0);
    let pf = BigInt(1);
    for (let i = 0; i < str.length; i++) {
        const c = str[i].toString();
        const x = BigInt(cf.get(c));
        lower = lower * base + x * pf;
        pf = pf * BigInt(freq.get(c));
    }
    let upper = lower + pf;
    let powr = 0n;
    const bigRadix = BigInt(radix);
    while (true) {
        pf = pf / bigRadix;
        if (pf === 0n) break;
        powr++;
    }
    const diff = (upper - 1n) / (bigRadix ** powr)
    return { Item1: diff, Item2: powr, Item3: freq };
}

function ArithmeticDecoding(num, radix, pwr, freq) {
    const powr = BigInt(radix);
    let enc = BigInt(num) * powr ** BigInt(pwr);
    let sum = 0;
    freq.forEach(value => sum += value);
    const base = sum;

    const cf = CumulativeFreq(freq);
    const dict = new Map();
    cf.forEach((value, key) => dict.set(value, key));

    let lchar = -1;
    for (let i = 0; i < base; i++) {
        if (dict.has(i)) lchar = dict.get(i).charCodeAt(0);
        else if (lchar !== -1) dict.set(i, String.fromCharCode(lchar));
    }
    const decoded = new Array(base);
    const bigBase = BigInt(base);
    for (let i = base - 1; i >= 0; --i) {
        const pow = bigBase ** BigInt(i);
        const div = enc / pow;
        const c = dict.get(Number(div));
        const fv = BigInt(freq.get(c));
        const cv = BigInt(cf.get(c));
        const diff = BigInt(enc - pow * cv);
        enc = diff / fv;
        decoded[base - 1 - i] = c;
    }
    return decoded.join("");
}

function Main() {
    const radix = 10;
    const strings = ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"];
    for (const str of strings) {
        const encoded = ArithmeticCoding(str, radix);
        const dec = ArithmeticDecoding(encoded.Item1, radix, encoded.Item2, encoded.Item3);
        console.log(`${str.padEnd(25, " ")}=> ${encoded.Item1.toString(10).padStart(19, " ")} * ${radix}^${encoded.Item2}`);
        if (str !== dec) {
            throw new Error("\tHowever that is incorrect!");
        }
    }
}
