class FifteenSolver {
    constructor(n, g) {
        this.Nr = [3,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3];
        this.Nc = [3,0,1,2,3,0,1,2,3,0,1,2,3,0,1,2];
        this.n = 0;
        this._n = 0;
        this.N0 = new Array(100).fill(0);
        this.N3 = new Array(100).fill('');
        this.N4 = new Array(100).fill(0);
        this.N2 = new Array(100).fill(0n);
        this.N0[0] = n;
        this.N2[0] = BigInt(g);
    }

    fY() {
        if (this.N4[this.n] < this._n) return this.fN();
        if (this.N2[this.n] === 0x123456789abcdef0n) {
            let moves = '';
            for (let g = 1; g <= this.n; g++) moves += this.N3[g];
            console.log(`Solution found in ${this.n} moves: ${moves}`);
            return true;
        }
        if (this.N4[this.n] === this._n) return this.fN();
        return false;
    }

    fN() {
        if (this.N3[this.n] !== 'u' && Math.floor(this.N0[this.n]/4) < 3) {
            this.fI();
            this.n++;
            if (this.fY()) return true;
            this.n--;
        }
        if (this.N3[this.n] !== 'd' && Math.floor(this.N0[this.n]/4) > 0) {
            this.fG();
            this.n++;
            if (this.fY()) return true;
            this.n--;
        }
        if (this.N3[this.n] !== 'l' && this.N0[this.n]%4 < 3) {
            this.fE();
            this.n++;
            if (this.fY()) return true;
            this.n--;
        }
        if (this.N3[this.n] !== 'r' && this.N0[this.n]%4 > 0) {
            this.fL();
            this.n++;
            if (this.fY()) return true;
            this.n--;
        }
        return false;
    }

    fI() {
        const g = (11 - this.N0[this.n]) * 4;
        const a = this.N2[this.n] & (15n << BigInt(g));
        this.N0[this.n + 1] = this.N0[this.n] + 4;
        this.N2[this.n + 1] = this.N2[this.n] - a + (a << 16n);
        this.N3[this.n + 1] = 'd';
        this.N4[this.n + 1] = this.N4[this.n] + (this.Nr[Number(a >> BigInt(g))] <= Math.floor(this.N0[this.n]/4) ? 0 : 1);
    }

    fG() {
        const g = (19 - this.N0[this.n]) * 4;
        const a = this.N2[this.n] & (15n << BigInt(g));
        this.N0[this.n + 1] = this.N0[this.n] - 4;
        this.N2[this.n + 1] = this.N2[this.n] - a + (a >> 16n);
        this.N3[this.n + 1] = 'u';
        this.N4[this.n + 1] = this.N4[this.n] + (this.Nr[Number(a >> BigInt(g))] >= Math.floor(this.N0[this.n]/4) ? 0 : 1);
    }

    fE() {
        const g = (14 - this.N0[this.n]) * 4;
        const a = this.N2[this.n] & (15n << BigInt(g));
        this.N0[this.n + 1] = this.N0[this.n] + 1;
        this.N2[this.n + 1] = this.N2[this.n] - a + (a << 4n);
        this.N3[this.n + 1] = 'r';
        this.N4[this.n + 1] = this.N4[this.n] + (this.Nc[Number(a >> BigInt(g))] <= this.N0[this.n]%4 ? 0 : 1);
    }

    fL() {
        const g = (16 - this.N0[this.n]) * 4;
        const a = this.N2[this.n] & (15n << BigInt(g));
        this.N0[this.n + 1] = this.N0[this.n] - 1;
        this.N2[this.n + 1] = this.N2[this.n] - a + (a >> 4n);
        this.N3[this.n + 1] = 'l';
        this.N4[this.n + 1] = this.N4[this.n] + (this.Nc[Number(a >> BigInt(g))] >= this.N0[this.n]%4 ? 0 : 1);
    }

    solve() {
        while (!this.fY()) this._n++;
    }
}

const start = new FifteenSolver(8, '0xfe169b4c0a73d852');
start.solve();
