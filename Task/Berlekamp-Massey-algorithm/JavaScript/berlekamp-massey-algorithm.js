class BerlekampMassey {
    constructor(source, modulus) {
        this.source = [...source];
        this.modulus = modulus;
    }

    computeCoefficients() {
        let result = [];
        let previousResult = [];
        let failIndex = -1;

        for (let i = 0; i < this.source.length; i++) {
            let delta = this.source[i];
            for (let j = 1; j <= result.length; j++) {
                delta -= result[j - 1] * this.source[i - j];
            }

            if (delta === 0) {
                continue;
            }

            if (failIndex === -1) {
                result = new Array(i + 1).fill(0);
                failIndex = i;
            } else {
                let previousResultCopy = [1];
                for (let term of previousResult) {
                    previousResultCopy.push(-term);
                }

                let termFailIndexPlusOne = 0;
                for (let j = 1; j <= previousResultCopy.length; j++) {
                    termFailIndexPlusOne += previousResultCopy[j - 1] * this.source[failIndex + 1 - j];
                }

                const coeff = Math.floor(delta / termFailIndexPlusOne);
                for (let k = 0; k < previousResultCopy.length; k++) {
                    previousResultCopy[k] = previousResultCopy[k] * coeff;
                }

                for (let k = 0; k < i - failIndex - 1; k++) {
                    previousResultCopy.unshift(0);
                }

                let resultCopy = [...result];
                while (result.length < previousResultCopy.length) {
                    result.push(0);
                }

                for (let j = 0; j < previousResultCopy.length; j++) {
                    result[j] = result[j] + previousResultCopy[j];
                }

                if (i - resultCopy.length > failIndex - previousResult.length) {
                    previousResult = [...resultCopy];
                    failIndex = i;
                }
            }
        }
        return result;
    }

    computeTerm(bmCoeffs, index) {
        if (bmCoeffs.length === 0) {
            return 0;
        }

        if (index < this.source.length) {
            return (this.source[index] + this.modulus) % this.modulus;
        }

        let coeffs = [this.modulus - 1];
        coeffs.push(...bmCoeffs);

        const bmCoeffsSize = bmCoeffs.length;
        let f = new Array(bmCoeffsSize).fill(0);
        let g = new Array(bmCoeffsSize).fill(0);

        f[0] = 1;

        if (bmCoeffsSize === 1) {
            g[0] = coeffs[1];
        } else {
            g[1] = 1;
        }

        let power = index - 1;
        while (power > 0) {
            if ((power & 1) === 1) {
                f = this.polynomialMultiply(f, g, bmCoeffsSize, coeffs);
            }
            g = this.polynomialMultiply(g, g, bmCoeffsSize, coeffs);
            power >>= 1;
        }

        let result = 0;
        for (let i = 0; i < bmCoeffsSize; i++) {
            if (i + 1 < this.source.length) {
                result = (result + this.source[i + 1] * f[i]) % this.modulus;
            }
        }
        return (result + this.modulus) % this.modulus;
    }

    polynomial(bmCoeffs) {
        const degree = bmCoeffs.length - 1;
        if (degree === 0) {
            return String(bmCoeffs[0]);
        }

        let text = '';
        for (let i = degree; i >= 0; i--) {
            const coeff = bmCoeffs[i];
            if (coeff === 0) {
                continue;
            }

            let sign = (coeff < 0 && i === degree) ?
                '-' : (coeff < 0) ? ' - ' : (i < degree) ? ' + ' : '';
            text += sign;

            const coeffAbs = Math.abs(coeff);
            if (coeffAbs > 1) {
                text += coeffAbs;
            }

            let term = (i > 1) ? `x^${i}` : (i === 1) ?
                'x' : (coeffAbs === 1) ? '1' : '';
            text += term;
        }
        return text;
    }

    polynomialMultiply(a, b, degree, coeffs) {
        let result = new Array(2 * degree).fill(0);

        for (let i = 0; i < degree; i++) {
            if (a[i] === 0) {
                continue;
            }
            for (let j = 0; j < degree; j++) {
                result[i + j] = (result[i + j] + a[i] * b[j]) % this.modulus;
            }
        }

        for (let i = 2 * degree - 1; i > degree - 1; i--) {
            if (result[i] === 0) {
                continue;
            }

            const term = result[i];
            result[i] = 0;

            for (let j = 0; j <= degree; j++) {
                const index = i - j;
                if (index >= 0) {
                    result[index] = (result[index] + term * coeffs[j]) % this.modulus;
                }
            }
        }
        return result.slice(0, degree);
    }
}

// Main execution
function main() {
    const source = [0, 1, 1, 2, 3, 5, 8, 13, 21];
    const bm = new BerlekampMassey(source, 100);
    const bmCoeffs = bm.computeCoefficients();

    console.log(`Berlekamp-Massey coefficients: [${bmCoeffs.join(', ')}] (lowest to highest degree)`);
    console.log(`The connection polynomial is ${bm.polynomial(bmCoeffs)} having degree ${bmCoeffs.length - 1}\n`);

    console.log('Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:');
    // Result can be checked on www.oeis.net, A000045
    const indices = [35, 36, 37, 38, 39, 40];
    const terms = indices.map(n => bm.computeTerm(bmCoeffs, n));
    console.log(terms.join(' '));
}

// Run the main function
main();
