class ErdosWoods {

    static class_Partition(setA, setB, rPrimes) {
        return {
            setA: setA,
            setB: setB,
            rPrimes: rPrimes
        };
    }

    static erdosWoods(n) {
        const primes = [];
        // P grows very fast (product of squares), so we use BigInt to avoid precision loss
        // that would occur with standard JS Numbers, ensuring the modulo check works correctly.
        let P = 1n;
        let k = 1;
        while (k < n) {
            if (P % BigInt(k) !== 0n) {
                primes.push(k);
            }
            P *= BigInt(k) * BigInt(k);
            k++;
        }

        const divs = new Int32Array(n);
        for (let a = 0; a < n; a++) {
            let val = 0;
            for (let i = 0; i < primes.length; i++) {
                // If a is divisible by the i-th prime, set the i-th bit.
                // This mimics the Java logic: append "1" or "0", then reverse and parse.
                // In binary construction:
                // p[0] is LSB. p[1] is 2nd bit, etc.
                if (a % primes[i] === 0) {
                    val |= (1 << i);
                }
            }
            divs[a] = val;
        }

        const np = primes.length;
        let partitions = [this.class_Partition(0, 0, (1 << np) - 1)];

        const indices = [];
        for (let i = 1; i < n; i++) {
            indices.push(i);
        }

        // Sort indices based on the position of the highest set bit in (divs[i] | divs[n-i])
        indices.sort((i, j) => {
            const valA = divs[i] | divs[n - i];
            const valB = divs[j] | divs[n - j];

            // Getting the last index of '1' in binary representation
            // equivalent to checking the most significant bit position relevant to the string length
            const aBits = valA.toString(2);
            const bBits = valB.toString(2);

            // Note: toString(2) does not have leading zeros,
            // but lastIndexOf('1') relative to the string end is what matters?
            // The Java code uses .lastIndexOf('1') on the standard binary string.
            // "100" -> lastIndex is 0. "001" (if padding existed) -> lastIndex 2.
            // Java's Integer.toBinaryString("100") is "100". lastIndexOf('1') is 0.
            // Java's Integer.toBinaryString("110") is "110". lastIndexOf('1') is 1.
            // Actually, lastIndexOf finds the *last occurrence*.
            // "101" -> index 0 ('1'), index 1 ('0'), index 2 ('1'). lastIndexOf is 2.
            // This effectively finds the Least Significant Bit's index in the string representation?
            // No, string index 0 is MSB in printing.
            // Let's stick strictly to string manipulation to match Java behavior exactly.

            const aPos = aBits.lastIndexOf('1');
            const bPos = bBits.lastIndexOf('1');
            return bPos - aPos; // Descending sort
        });

        for (const i of indices) {
            const newPartitions = [];
            const factors = divs[i];
            const otherFactors = divs[n - i];

            for (const p of partitions) {
                const { setA, setB, rPrimes } = p;

                if ((factors & setA) !== 0 || (otherFactors & setB) !== 0) {
                    newPartitions.push(p);
                    continue;
                }

                // Expand Set A
                const factorsBits = factors & rPrimes;
                // Iterate over bits. Java code reversed string bits to map
                // string index to bit position (0 -> 1<<0, 1 -> 1<<1).
                // We can simply iterate 32 bits.
                for (let ix = 0; ix < 32; ix++) {
                    const w = 1 << ix;
                    if ((factorsBits & w) !== 0) {
                        newPartitions.push(this.class_Partition(setA ^ w, setB, rPrimes ^ w));
                    }
                }

                // Expand Set B
                const otherBits = otherFactors & rPrimes;
                for (let ix = 0; ix < 32; ix++) {
                    const w = 1 << ix;
                    if ((otherBits & w) !== 0) {
                        newPartitions.push(this.class_Partition(setA, setB ^ w, rPrimes ^ w));
                    }
                }
            }
            partitions = newPartitions;
        }

        let result = Infinity;
        for (const partition of partitions) {
            let px = partition.setA;
            let py = partition.setB;
            let x = 1;
            let y = 1;

            for (const p of primes) {
                if ((px & 1) !== 0) {
                    x *= p;
                }
                if ((py & 1) !== 0) {
                    y *= p;
                }
                px >>= 1;
                py >>= 1;
            }

            const inv = this.modInverse(x, y);
            // JS modulo operator can behave differently with negatives,
            // but here numbers are positive.
            const val = ((n * inv) % y) * x - n;
            if (val < result) {
                result = val;
            }
        }
        return result;
    }

    static modInverse(a, m) {
        a = a % m;
        for (let x = 1; x < m; x++) {
            if ((a * x) % m === 1) {
                return x;
            }
        }
        return 1;
    }

    static main() {
        let K = 3;
        let COUNT = 0;
        console.log("The first 20 Erdős--Woods numbers and their minimum interval start values are:");
        while (COUNT < 20) {
            const a = this.erdosWoods(K);
            if (a !== Infinity) {
                // Formatting to match printf("%3d -> %.0f%n")
                console.log(`${K.toString().padStart(3, ' ')} -> ${a.toFixed(0)}`);
                COUNT++;
            }
            K++;
        }
    }
}

// Execute main
ErdosWoods.main();
