class PValueCorrection {
    static seqLen(start, end) {
        let result;
        if (start === end) {
            result = new Array(end + 1);
            for (let i = 0; i < result.length; ++i) {
                result[i] = i + 1;
            }
        } else if (start < end) {
            result = new Array(end - start + 1);
            for (let i = 0; i < result.length; ++i) {
                result[i] = start + i;
            }
        } else {
            result = new Array(start - end + 1);
            for (let i = 0; i < result.length; ++i) {
                result[i] = start - i;
            }
        }
        return result;
    }

    static order(array, decreasing) {
        const size = array.length;
        const idx = new Array(size);
        const baseArr = new Array(size);
        for (let i = 0; i < size; ++i) {
            baseArr[i] = array[i];
            idx[i] = i;
        }
        idx.sort((a, b) => {
            if (!decreasing) {
                return baseArr[a] - baseArr[b];
            } else {
                return baseArr[b] - baseArr[a];
            }
        });
        return idx;
    }

    static cummin(array) {
        if (array.length < 1) throw new Error("cummin requires at least one element");
        const output = new Array(array.length);
        let cumulativeMin = array[0];
        for (let i = 0; i < array.length; ++i) {
            if (array[i] < cumulativeMin) cumulativeMin = array[i];
            output[i] = cumulativeMin;
        }
        return output;
    }

    static cummax(array) {
        if (array.length < 1) throw new Error("cummax requires at least one element");
        const output = new Array(array.length);
        let cumulativeMax = array[0];
        for (let i = 0; i < array.length; ++i) {
            if (array[i] > cumulativeMax) cumulativeMax = array[i];
            output[i] = cumulativeMax;
        }
        return output;
    }

    static pminx(array, x) {
        if (array.length < 1) throw new Error("pmin requires at least one element");
        const result = new Array(array.length);
        for (let i = 0; i < array.length; ++i) {
            result[i] = array[i] < x ? array[i] : x;
        }
        return result;
    }

    static doubleSay(array) {
        process.stdout.write(`[ 1] ${array[0].toExponential()}`);
        for (let i = 1; i < array.length; ++i) {
            process.stdout.write(` ${array[i].toFixed(10)}`);
            if ((i + 1) % 5 === 0) process.stdout.write(`\n[${(i + 1).toString().padStart(2, ' ')}]`);
        }
        console.log();
    }

    static intToDouble(array) {
        const result = new Array(array.length);
        for (let i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    static doubleArrayMin(array) {
        if (array.length < 1) throw new Error("pAdjust requires at least one element");
        return Math.min(...array);
    }

    static pAdjust(pvalues, str) {
        const size = pvalues.length;
        if (size < 1) throw new Error("pAdjust requires at least one element");
        let type;
        switch (str.toLowerCase()) {
            case "bh":
            case "fdr":
                type = 0;
                break;
            case "by":
                type = 1;
                break;
            case "bonferroni":
                type = 2;
                break;
            case "hochberg":
                type = 3;
                break;
            case "holm":
                type = 4;
                break;
            case "hommel":
                type = 5;
                break;
            default:
                throw new Error(`${str} doesn't match any accepted FDR types`);
        }

        if (type === 2) { // Bonferroni method
            const result = new Array(size);
            for (let i = 0; i < size; ++i) {
                const b = pvalues[i] * size;
                result[i] = b >= 1 ? 1 : (0 <= b && b < 1 ? b : (() => { throw new Error(`${b} is outside [0, 1)`); })());
            }
            return result;
        } else if (type === 4) { // Holm method
            const o = this.order(pvalues, false);
            const o2Double = this.intToDouble(o);
            const cummaxInput = new Array(size);
            for (let i = 0; i < size; ++i) {
                cummaxInput[i] = (size - i) * pvalues[o[i]];
            }
            const ro = this.order(o2Double, false);
            const cummaxOutput = this.cummax(cummaxInput);
            const pmin = this.pminx(cummaxOutput, 1.0);
            const result = new Array(size);
            for (let i = 0; i < size; ++i) {
                result[i] = pmin[ro[i]];
            }
            return result;
        } else if (type === 5) { // Hommel method
            const indices = this.seqLen(size, size);
            const o = this.order(pvalues, false);
            const p = new Array(size);
            for (let i = 0; i < size; ++i) {
                p[i] = pvalues[o[i]];
            }
            const o2Double = this.intToDouble(o);
            const ro = this.order(o2Double, false);
            const q = new Array(size).fill(0);
            const pa = new Array(size).fill(0);
            const npi = new Array(size);
            for (let i = 0; i < size; ++i) {
                npi[i] = p[i] * size / indices[i];
            }
            const min = this.doubleArrayMin(npi);
            q.fill(min);
            pa.fill(min);
            for (let j = size; j >= 2; --j) {
                const ij = this.seqLen(1, size - j + 1).map(x => x - 1);
                const i2Length = j - 1;
                const i2 = new Array(i2Length);
                for (let i = 0; i < i2Length; ++i) {
                    i2[i] = size - j + 2 + i - 1;
                }
                let q1 = j * p[i2[0]] / 2.0;
                for (let i = 1; i < i2Length; ++i) {
                    const temp_q1 = p[i2[i]] * j / (2.0 + i);
                    if (temp_q1 < q1) q1 = temp_q1;
                }
                for (let i = 0; i < size - j + 1; ++i) {
                    q[ij[i]] = Math.min(p[ij[i]] * j, q1);
                }
                for (let i = 0; i < i2Length; ++i) {
                    q[i2[i]] = q[size - j];
                }
                for (let i = 0; i < size; ++i) {
                    if (pa[i] < q[i]) {
                        pa[i] = q[i];
                    }
                }
            }
            const result = new Array(size);
            for (let i = 0; i < size; ++i) {
                result[i] = pa[ro[i]];
            }
            return result;
        }

        const ni = new Array(size);
        const o = this.order(pvalues, true);
        const oDouble = this.intToDouble(o);
        for (let i = 0; i < size; ++i) {
            if (pvalues[i] < 0 || pvalues[i] > 1) {
                throw new Error(`array[${i}] = ${pvalues[i]} is outside [0, 1]`);
            }
            ni[i] = size / (size - i);
        }
        const ro = this.order(oDouble, false);
        const cumminInput = new Array(size);
        if (type === 0) { // BH method
            for (let i = 0; i < size; ++i) {
                cumminInput[i] = ni[i] * pvalues[o[i]];
            }
        } else if (type === 1) { // BY method
            let q = 0;
            for (let i = 1; i < size + 1; ++i) {
                q += 1.0 / i;
            }
            for (let i = 0; i < size; ++i) {
                cumminInput[i] = q * ni[i] * pvalues[o[i]];
            }
        } else if (type === 3) { // Hochberg method
            for (let i = 0; i < size; ++i) {
                cumminInput[i] = (i + 1) * pvalues[o[i]];
            }
        }
        const cumminArray = this.cummin(cumminInput);
        const pmin = this.pminx(cumminArray, 1.0);
        const result = new Array(size);
        for (let i = 0; i < size; ++i) {
            result[i] = pmin[ro[i]];
        }
        return result;
    }
}

// Example usage (similar to Java's main method)
const pvalues = [
    4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
    8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
    4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
    8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
    3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
    1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
    4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
    3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
    1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
    2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
];

const correctAnswers = [
    [ // Benjamini-Hochberg
        6.126681e-01, 8.521710e-01, 1.987205e-01, 1.891595e-01, 3.217789e-01,
        9.301450e-01, 4.870370e-01, 9.301450e-01, 6.049731e-01, 6.826753e-01,
        6.482629e-01, 7.253722e-01, 5.280973e-01, 8.769926e-01, 4.705703e-01,
        9.241867e-01, 6.049731e-01, 7.856107e-01, 4.887526e-01, 1.136717e-01,
        4.991891e-01, 8.769926e-01, 9.991834e-01, 3.217789e-01, 9.301450e-01,
        2.304958e-01, 5.832475e-01, 3.899547e-02, 8.521710e-01, 1.476843e-01,
        1.683638e-02, 2.562902e-03, 3.516084e-02, 6.250189e-02, 3.636589e-03,
        2.562902e-03, 2.946883e-02, 6.166064e-03, 3.899547e-02, 2.688991e-03,
        4.502862e-04, 1.252228e-05, 7.881555e-02, 3.142613e-02, 4.846527e-03,
        2.562902e-03, 4.846527e-03, 1.101708e-03, 7.252032e-02, 2.205958e-02
    ],
    [ // Benjamini & Yekutieli
        1.000000e+00, 1.000000e+00, 8.940844e-01, 8.510676e-01, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 5.114323e-01,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.754486e-01, 1.000000e+00, 6.644618e-01,
        7.575031e-02, 1.153102e-02, 1.581959e-01, 2.812089e-01, 1.636176e-02,
        1.153102e-02, 1.325863e-01, 2.774239e-02, 1.754486e-01, 1.209832e-02,
        2.025930e-03, 5.634031e-05, 3.546073e-01, 1.413926e-01, 2.180552e-02,
        1.153102e-02, 2.180552e-02, 4.956812e-03, 3.262838e-01, 9.925057e-02
    ],
    [ // Bonferroni
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 7.019185e-01, 1.000000e+00, 1.000000e+00,
        2.020365e-01, 1.516674e-02, 5.625735e-01, 1.000000e+00, 2.909271e-02,
        1.537741e-02, 4.125636e-01, 6.782670e-02, 6.803480e-01, 1.882294e-02,
        9.005725e-04, 1.252228e-05, 1.000000e+00, 4.713920e-01, 4.395577e-02,
        1.088915e-02, 4.846527e-02, 3.305125e-03, 1.000000e+00, 2.867745e-01
    ],
    [ // Hochberg
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 4.632662e-01, 9.991834e-01, 9.991834e-01,
        1.575885e-01, 1.383967e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
        1.383967e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
        8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
        1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
    ],
    [ // Holm
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
        1.000000e+00, 1.000000e+00, 4.632662e-01, 1.000000e+00, 1.000000e+00,
        1.575885e-01, 1.395341e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
        1.395341e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
        8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
        1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
    ],
    [ // Hommel
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.987624e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.595180e-01,
        9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
        9.991834e-01, 9.991834e-01, 4.351895e-01, 9.991834e-01, 9.766522e-01,
        1.414256e-01, 1.304340e-02, 3.530937e-01, 6.887709e-01, 2.385602e-02,
        1.322457e-02, 2.722920e-01, 5.426136e-02, 4.218158e-01, 1.581127e-02,
        8.825610e-04, 1.252228e-05, 8.743649e-01, 3.016908e-01, 3.516461e-02,
        9.582456e-03, 3.877222e-02, 3.172920e-03, 8.122276e-01, 1.950067e-01
    ]
];


const types = ["bh", "by", "bonferroni", "hochberg", "holm", "hommel"];

for (let type = 0; type < types.length; ++type) {
    const q = PValueCorrection.pAdjust(pvalues, types[type]);
    let error = 0.0;
    for (let i = 0; i < pvalues.length; ++i) {
        error += Math.abs(q[i] - correctAnswers[type][i]);
    }
    PValueCorrection.doubleSay(q);
    console.log(`\ntype ${type} = '${types[type]}' has a cumulative error of ${error}`);
}
