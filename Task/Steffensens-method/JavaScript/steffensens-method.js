class Steffensen {
    static aitken(p0) {
        const p1 = this.f(p0);
        const p2 = this.f(p1);
        const p1m0 = p1 - p0;
        return p0 - p1m0 * p1m0 / (p2 - 2.0 * p1 + p0);
    }

    static steffensenAitken(pinit, tol, maxiter) {
        let p0 = pinit;
        let p = this.aitken(p0);
        let iter = 1;
        while (Math.abs(p - p0) > tol && iter < maxiter) {
            p0 = p;
            p = this.aitken(p0);
            iter++;
        }
        if (Math.abs(p - p0) > tol) return null;
        return p;
    }

    static deCasteljau(c0, c1, c2, t) {
        const s = 1.0 - t;
        const c01 = s * c0 + t * c1;
        const c12 = s * c1 + t * c2;
        return s * c01 + t * c12;
    }

    static xConvexLeftParabola(t) {
        return this.deCasteljau(2.0, -8.0, 2.0, t);
    }

    static yConvexRightParabola(t) {
        return this.deCasteljau(1.0, 2.0, 3.0, t);
    }

    static implicitEquation(x, y) {
        return 5.0 * x * x + y - 5.0;
    }

    static f(t) {
        const x = this.xConvexLeftParabola(t);
        const y = this.yConvexRightParabola(t);
        return this.implicitEquation(x, y) + t;
    }

    static main() {
        let t0 = 0.0;
        for (let i = 0; i < 11; ++i) {
            process.stdout.write(`t0 = ${t0.toFixed(1)} : `);
            const t = this.steffensenAitken(t0, 0.00000001, 1000);
            if (t === null) {
                console.log("no answer");
            } else {
                const x = this.xConvexLeftParabola(t);
                const y = this.yConvexRightParabola(t);
                if (Math.abs(this.implicitEquation(x, y)) <= 0.000001) {
                    console.log(`intersection at (${x}, ${y})`);
                } else {
                    console.log("spurious solution");
                }
            }
            t0 += 0.1;
        }
    }
}

// Run the main function
Steffensen.main();
