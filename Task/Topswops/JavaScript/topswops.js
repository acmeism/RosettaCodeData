class Topswops {
    static maxBest = 32;
    static best = new Array(Topswops.maxBest).fill(0);

    static trySwaps(deck, f, d, n) {
        if (d > this.best[n]) {
            this.best[n] = d;
        }
        for (let i = n - 1; i >= 0; i--) {
            if (deck[i] === -1 || deck[i] === i) {
                break;
            }
            if (d + this.best[i] <= this.best[n]) {
                return;
            }
        }
        let deck2 = [...deck];
        for (let i = 1; i < n; i++) {
            const k = 1 << i;
            if (deck2[i] === -1) {
                if ((f & k) !== 0) {
                    continue;
                }
            } else if (deck2[i] !== i) {
                continue;
            }
            deck2[0] = i;
            for (let j = i - 1; j >= 0; j--) {
                deck2[i - j] = deck[j]; // Reverse copy.
            }
            this.trySwaps(deck2, f | k, d + 1, n);
        }
    }

    static topswops(n) {
        if (n <= 0 || n >= this.maxBest) {
            throw new Error("n must be between 1 and maxBest");
        }
        this.best[n] = 0;
        let deck0 = new Array(n + 1).fill(0);
        for (let i = 1; i < n; i++) {
            deck0[i] = -1;
        }
        this.trySwaps(deck0, 1, 0, n);
        return this.best[n];
    }

    static main() {
        for (let i = 1; i < 11; i++) {
            console.log(`${i}: ${this.topswops(i)}`);
        }
    }
}

// Run the main function
Topswops.main();
