class SOfN {
    constructor(n) {
        this.m = this.n = n
        this.s = []
    }

    add(item) {
        if (this.s.length < this.n) {
            this.s.push(item)
        } else {
            const rand = Math.floor(Math.random() * ++this.m)
            if (rand < this.n) {
                this.s[rand] = item
            }
        }
    }
}

function main() {
    for (const [n, m] of [[3, 3], [3, 10]]) {
        const freqs = new Array(m).fill(0)

        for (let i = 0; i < 1e5; ++i) {
            const sOfN = new SOfN(n)
            for (let x = 0; x < m; ++x) {
                sOfN.add(x)
            }
            for (const d of sOfN.s) {
                ++freqs[d]
            }
        }
        console.log(`Results for n=${n}, m=${m}: [${freqs.join(', ')}]`)
    }
}

main()
