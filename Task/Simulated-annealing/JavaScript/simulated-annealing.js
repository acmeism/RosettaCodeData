class SimulatedAnnealingTSP {
    constructor() {
        this.dists = this.calcDists();
        this.dirs = [1, -1, 10, -10, 9, 11, -11, -9]; // all 8 neighbors
    }

    // Calculate distances lookup table
    calcDists() {
        const dists = new Array(10000);
        for (let i = 0; i < 10000; i++) {
            const ab = Math.floor(i / 100.0);
            const cd = i % 100;
            const a = Math.floor(ab / 10);
            const b = Math.floor(ab % 10);
            const c = Math.floor(cd / 10);
            const d = Math.floor(cd % 10);
            dists[i] = Math.hypot(a - c, b - d);
        }
        return dists;
    }

    // Index into lookup table of doubles
    dist(ci, cj) {
        return this.dists[cj * 100 + ci];
    }

    // Energy at s, to be minimized
    Es(path) {
        let d = 0.0;
        for (let i = 0; i < path.length - 1; i++) {
            d += this.dist(path[i], path[i + 1]);
        }
        return d;
    }

    // Temperature function, decreases to 0
    T(k, kmax, kT) {
        return (1 - k / kmax) * kT;
    }

    // Variation of E, from state s to state s_next
    dE(s, u, v) {
        const su = s[u], sv = s[v];
        // old
        const a = this.dist(s[u - 1], su);
        const b = this.dist(s[u + 1], su);
        const c = this.dist(s[v - 1], sv);
        const d = this.dist(s[v + 1], sv);
        // new
        const na = this.dist(s[u - 1], sv);
        const nb = this.dist(s[u + 1], sv);
        const nc = this.dist(s[v - 1], su);
        const nd = this.dist(s[v + 1], su);

        if (v === u + 1) {
            return (na + nd) - (a + d);
        } else if (u === v + 1) {
            return (nc + nb) - (c + b);
        } else {
            return (na + nb + nc + nd) - (a + b + c + d);
        }
    }

    // Probability to move from s to s_next
    P(deltaE, k, kmax, kT) {
        return Math.exp(-deltaE / this.T(k, kmax, kT));
    }

    // Fisher-Yates shuffle algorithm
    shuffle(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
    }

    sa(kmax, kT) {
        // Create temp array with values 1 to 99
        const temp = Array.from({length: 99}, (_, i) => i + 1);
        this.shuffle(temp);

        // Initialize path array
        const s = new Array(101).fill(0);
        for (let i = 0; i < 99; i++) {
            s[i + 1] = temp[i]; // random path from 0 to 0
        }

        console.log(`kT = ${kT}`);
        console.log(`E(s0) ${this.Es(s).toFixed(6)}\n`); // random starter

        let Emin = this.Es(s); // E0

        for (let k = 0; k <= kmax; k++) {
            if (k % Math.floor(kmax / 10) === 0) {
                console.log(`k:${k.toString().padStart(10)}   T: ${this.T(k, kmax, kT).toFixed(4).padStart(8)}   Es: ${this.Es(s).toFixed(4).padStart(8)}`);
            }

            const u = 1 + Math.floor(Math.random() * 99); // city index 1 to 99
            const cv = s[u] + this.dirs[Math.floor(Math.random() * 8)]; // city number

            if (cv <= 0 || cv >= 100) { // bogus city
                continue;
            }

            if (this.dist(s[u], cv) > 5) { // check true neighbor (eg 0 9)
                continue;
            }

            const v = s[cv]; // city index
            const deltae = this.dE(s, u, v);

            if (deltae < 0 || // always move if negative
                this.P(deltae, k, kmax, kT) >= Math.random()) {
                // Swap s[u] and s[v]
                [s[u], s[v]] = [s[v], s[u]];
                Emin += deltae;
            }
        }

        console.log(`\nE(s_final) ${Emin.toFixed(6)}`);
        console.log("Path:");

        // Output final state
        let output = "";
        for (let i = 0; i < s.length; i++) {
            if (i > 0 && i % 10 === 0) {
                output += "\n";
            }
            output += s[i].toString().padStart(4);
        }
        console.log(output);
    }
}

// Usage
const tsp = new SimulatedAnnealingTSP();
tsp.sa(1000000, 1);
