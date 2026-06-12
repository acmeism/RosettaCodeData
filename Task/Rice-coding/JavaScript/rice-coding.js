const Type = {
    STANDARD: 'STANDARD',
    EXTENDED: 'EXTENDED'
};

class Rice {
    static encode(n, k, type) {
        let value = n;
        if (type === Type.EXTENDED) {
            value = value < 0 ? -value * 2 - 1 : 2 * value;
        }

        if (value < 0) {
            throw new Error("n cannot be negative: " + n);
        }

        const m = 1 << k;
        const quotient = Math.floor(value / m);
        const remainder = value % m;
        const ones = '1'.repeat(quotient);
        const binary = remainder.toString(2);
        const remainderBinary = '0'.repeat(k + 1 - binary.length) + binary;

        return ones + remainderBinary;
    }

    static decode(encoded, k, type) {
        const m = 1 << k;
        const quotient = Math.max(0, encoded.indexOf('0'));
        const remainder = parseInt(encoded.substring(quotient), 2);
        let result = quotient * m + remainder;

        if (type === Type.EXTENDED) {
            result = result % 2 === 1 ? -((result + 1) / 2) : result / 2;
        }

        return result;
    }
}

// Example usage
console.log("Base Rice Coding with k = 2:");
for (let n = 0; n <= 10; n++) {
    const encoded = Rice.encode(n, 2, Type.STANDARD);
    console.log(`${n} -> ${encoded} -> ${Rice.decode(encoded, 2, Type.STANDARD)}`);
}

console.log("\nExtended Rice Coding with k = 2:");
for (let n = -10; n <= 10; n++) {
    const encoded = Rice.encode(n, 2, Type.EXTENDED);
    console.log(`${n} -> ${encoded} -> ${Rice.decode(encoded, 2, Type.EXTENDED)}`);
}

console.log("\nBase Rice Coding with k = 4:");
for (let n = 0; n <= 17; n++) {
    const encoded = Rice.encode(n, 4, Type.STANDARD);
    console.log(`${n} -> ${encoded} -> ${Rice.decode(encoded, 4, Type.STANDARD)}`);
}

