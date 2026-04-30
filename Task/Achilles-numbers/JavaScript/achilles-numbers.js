class AchillesNumbers {
    constructor() {
        this.pps = new Map(); // Stores perfect powers
    }

    // Euler's totient function
    totient(n) {
        let tot = n;
        let i = 2;
        while (i * i <= n) {
            if (n % i === 0) {
                // Remove all factors of i
                while (n % i === 0) {
                    n = Math.floor(n / i);
                }
                tot -= Math.floor(tot / i);
            }
            // Handle even/odd step correctly
            if (i === 2) {
                i = 1;
            }
            i += 2;
        }
        // If remaining n is a prime
        if (n > 1) {
            tot -= Math.floor(tot / n);
        }
        return tot;
    }

    // Generate all perfect powers up to 10^maxExp
    getPerfectPowers(maxExp) {
        const upper = Math.pow(10, maxExp);
        const sqrtUpper = Math.floor(Math.sqrt(upper));

        for (let i = 2; i <= sqrtUpper; i++) {
            let p = i;
            while (true) {
                p *= i;
                if (p >= upper) break;
                this.pps.set(Math.floor(p), true);
            }
        }
    }

    // Generate all Achilles numbers between 10^minExp and 10^maxExp
    getAchilles(minExp, maxExp) {
        const lower = Math.pow(10, minExp);
        const upper = Math.pow(10, maxExp);
        const achilles = new Map();

        const cbrtUpper = Math.floor(Math.cbrt(upper));
        for (let b = 1; b <= cbrtUpper; b++) {
            const b3 = b * b * b;
            const sqrtUpper = Math.floor(Math.sqrt(upper));

            for (let a = 1; a <= sqrtUpper; a++) {
                const p = b3 * a * a;
                if (p >= upper) break;

                if (p >= lower) {
                    if (!this.pps.has(p)) {
                        achilles.set(p, true);
                    }
                }
            }
        }
        return achilles;
    }

    static main() {
        const an = new AchillesNumbers();
        const maxDigits = 8;

        an.getPerfectPowers(maxDigits);
        const achillesSet = an.getAchilles(1, 5);

        // Convert map keys to sorted array
        const achilles = Array.from(achillesSet.keys()).sort((a, b) => a - b);

        // Print first 50 Achilles numbers
        console.log("First 50 Achilles numbers:");
        let output = "";
        for (let i = 0; i < 50; i++) {
            output += `${achilles[i].toString().padStart(4)} `;
            if ((i + 1) % 10 === 0) {
                console.log(output);
                output = "";
            }
        }
        if (output) console.log(output);

        // Print first 30 strong Achilles numbers
        console.log("\nFirst 30 strong Achilles numbers:");
        const strongAchilles = [];
        let count = 0;
        let idx = 0;

        while (count < 30 && idx < achilles.length) {
            const n = achilles[idx];
            const tot = an.totient(n);
            if (achillesSet.has(tot)) {
                strongAchilles.push(n);
                count++;
            }
            idx++;
        }

        output = "";
        for (let i = 0; i < 30; i++) {
            output += `${strongAchilles[i].toString().padStart(5)} `;
            if ((i + 1) % 10 === 0) {
                console.log(output);
                output = "";
            }
        }
        if (output) console.log(output);

        // Print counts per digit length
        console.log("\nNumber of Achilles numbers with:");
        for (let d = 2; d <= maxDigits; d++) {
            const ac = an.getAchilles(d - 1, d).size;
            console.log(`${d.toString().padStart(2)} digits: ${ac}`);
        }
    }
}

// Execute the main method
AchillesNumbers.main();
