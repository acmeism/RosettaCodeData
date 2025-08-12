class Complex {
    constructor(aReal, aImag) {
        this.real = aReal;
        this.imag = aImag;
    }

    add(other) {
        return new Complex(this.real + other.real, this.imag + other.imag);
    }

    subtract(other) {
        return new Complex(this.real - other.real, this.imag - other.imag);
    }

    multiply(other) {
        return new Complex(
            this.real * other.real - this.imag * other.imag,
            this.imag * other.real + this.real * other.imag
        );
    }

    divide(n) {
        if (typeof n === 'number') {
            return new Complex(this.real / n, this.imag / n);
        } else {
            // Assume n is another Complex
            const rr = this.real * n.real + this.imag * n.imag;
            const ii = this.imag * n.real - this.real * n.imag;
            const norm = n.real * n.real + n.imag * n.imag;
            return new Complex(rr / norm, ii / norm);
        }
    }

    real() {
        return this.real;
    }
}

// Static property for Complex
Complex.ZERO = new Complex(0.0, 0.0);

class ReturnValue {
    constructor(powerOfTwo, array) {
        this.powerOfTwo = powerOfTwo;
        this.array = array;
    }
}

function deconvolution1D(convolved, toRemove) {
    return deconvolution(
        convolved, convolved.length,
        toRemove, toRemove.length,
        1, convolved.length - toRemove.length + 1
    );
}

function deconvolution2D(convolved, toRemove) {
    const convolvedArray = unpack2D(convolved, convolved[0].length);
    const toRemoveArray = unpack2D(toRemove, convolved[0].length);
    const toRemainArray = deconvolution(
        convolvedArray, convolved.length * convolved[0].length,
        toRemoveArray, toRemove.length * convolved[0].length,
        convolved[0].length, (convolved[0].length - toRemove[0].length + 1) * convolved[0].length
    );

    return pack2D(
        toRemainArray,
        convolved.length - toRemove.length + 1,
        convolved[0].length - toRemove[0].length + 1,
        convolved[0].length
    );
}

function deconvolution3D(convolved, toRemove) {
    const cX = convolved.length;
    const cY = convolved[0].length;
    const cZ = convolved[0][0].length;

    const rX = toRemove.length;
    const rY = toRemove[0].length;
    const rZ = toRemove[0][0].length;

    const convolvedArray = unpack3D(convolved, cY, cZ);
    const toRemoveArray = unpack3D(toRemove, cY, cZ);
    const toRemainArray = deconvolution(
        convolvedArray, cX * cY * cZ,
        toRemoveArray, rX * cY * cZ,
        cY * cZ, (cX - rX + 1) * cY * cZ
    );

    return pack3D(toRemainArray, cX - rX + 1, cY - rY + 1, cZ - rZ + 1, cY, cZ);
}

function deconvolution(convolvedArray, convolvedLength, toRemoveArray, toRemoveLength, convolvedRowLength, toRemainLength) {
    let powerOfTwo = 0;
    let convolvedResult = padAndComplexify(convolvedArray, powerOfTwo);
    let convolvedPadded = convolvedResult.array;
    let toRemoveResult = padAndComplexify(toRemoveArray, convolvedResult.powerOfTwo);
    let toRemovePadded = toRemoveResult.array;
    powerOfTwo = toRemoveResult.powerOfTwo;

    fft(convolvedPadded, powerOfTwo);
    fft(toRemovePadded, powerOfTwo);
    let quotient = new Array(powerOfTwo);
    for (let i = 0; i < powerOfTwo; i++) {
        quotient[i] = convolvedPadded[i].divide(toRemovePadded[i]);
    }

    fft(quotient, powerOfTwo);
    for (let i = 0; i < powerOfTwo; i++) {
        if (Math.abs(quotient[i].real) < 0.0000000001) {
            quotient[i] = Complex.ZERO;
        }
    }

    let toRemainArray = new Array(toRemainLength);
    let i = 0;
    while (i > toRemoveLength - convolvedLength - convolvedRowLength) {
        toRemainArray[-i] = Math.round(
            quotient[(i + powerOfTwo) % powerOfTwo].divide(32).real
        );
        i -= 1;
    }
    return toRemainArray;
}

function fft(deconvolution1D, powerOfTwo) {
    const result = [...deconvolution1D];
    fftRecursive(deconvolution1D, result, powerOfTwo, 1, 0);
    return result;
}

function fftRecursive(deconvolution1D, result, powerOfTwo, step, start) {
    if (step < powerOfTwo) {
        fftRecursive(result, deconvolution1D, powerOfTwo, 2 * step, start);
        fftRecursive(result, deconvolution1D, powerOfTwo, 2 * step, start + step);

        for (let j = 0; j < powerOfTwo; j += 2 * step) {
            const theta = -Math.PI * j / powerOfTwo;
            const t = new Complex(Math.cos(theta), Math.sin(theta)).multiply(result[j + step + start]);
            deconvolution1D[(j / 2) + start] = result[j + start].add(t);
            deconvolution1D[((j + powerOfTwo) / 2) + start] = result[j + start].subtract(t);
        }
    }
}

function unpack2D(toUnpack, convolvedY) {
    let unpacked = new Array(toUnpack.length * convolvedY);
    for (let i = 0; i < toUnpack.length; i++) {
        for (let j = 0; j < toUnpack[0].length; j++) {
            unpacked[i * convolvedY + j] = toUnpack[i][j];
        }
    }
    return unpacked;
}

function unpack3D(toUnpack, convolvedY, convolvedZ) {
    let unpacked = new Array(toUnpack.length * convolvedY * convolvedZ);
    for (let i = 0; i < toUnpack.length; i++) {
        for (let j = 0; j < toUnpack[0].length; j++) {
            for (let k = 0; k < toUnpack[0][0].length; k++) {
                unpacked[(i * convolvedY + j) * convolvedZ + k] = toUnpack[i][j][k];
            }
        }
    }
    return unpacked;
}

function pack2D(toPack, toPackX, toPackY, convolvedY) {
    let packed = Array(toPackX).fill().map(() => Array(toPackY));
    for (let i = 0; i < toPackX; i++) {
        for (let j = 0; j < toPackY; j++) {
            packed[i][j] = Math.floor(toPack[i * convolvedY + j] / 4);
        }
    }
    return packed;
}

function pack3D(toPack, toPackX, toPackY, toPackZ, convolvedY, convolvedZ) {
    let packed = Array(toPackX).fill().map(() =>
        Array(toPackY).fill().map(() =>
            Array(toPackZ)
        )
    );

    for (let i = 0; i < toPackX; i++) {
        for (let j = 0; j < toPackY; j++) {
            for (let k = 0; k < toPackZ; k++) {
                packed[i][j][k] = Math.floor(toPack[(i * convolvedY + j) * convolvedZ + k] / 4);
            }
        }
    }
    return packed;
}

function padAndComplexify(array, powerOfTwo) {
    const paddedArrayLength = (powerOfTwo === 0) ?
        1 << (32 - Math.clz32(array.length - 1)) : powerOfTwo;

    let paddedArray = new Array(paddedArrayLength);
    for (let i = 0; i < paddedArrayLength; i++) {
        paddedArray[i] = (i < array.length) ? new Complex(array[i], 0.0) : Complex.ZERO;
    }
    return new ReturnValue(paddedArrayLength, paddedArray);
}

// Main function
function main() {
    const f1 = [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1];

    const g1 = [24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7];

    const h1 = [-8, -9, -3, -1, -6, 7];

    const f2 = [
        [-5,  2, -2, -6, -7],
        [9,  7, -6,  5, -7],
        [1, -1,  9,  2, -7],
        [5,  9, -9,  2, -5],
        [-8,  5, -2,  8,  5]
    ];

    const g2 = [
        [40,  -21,   53,   42,  105,    1,   87,   60,   39,   -28],
        [-92,  -64,   19, -167,  -71,  -47,  128, -109,   40,   -21],
        [58,   85,  -93,   37,  101,  -14,    5,   37,  -76,   -56],
        [-90, -135,   60, -125,   68,   53,  223,    4,  -36,   -48],
        [78,   16,    7, -199,  156, -162,   29,   28, -103,   -10],
        [-62,  -89,   69,  -61,   66,  193,  -61,   71,   -8,   -30],
        [48,   -6,   21,   -9, -150,  -22,  -56,   32,   85,    25]
    ];

    const h2 = [
        [-8,  1, -7, -2, -9,  4],
        [4,  5, -5,  2,  7, -1],
        [-6, -3, -3, -6,  9,  5]
    ];

    // const f3 = [
    //     [[- 9,  5, -8], [3,  5,  1]],
    //     [[-1, -7,  2], [-5, -6,  6]],
    //     [[8,  5,  8], [-2, -6, -4]]
    // ];

    // const g3 = [
    //     [
    //         [54,   42,   53,  -42,   85,  -72],
    //         [45, -170,   94,  -36,   48,   73],
    //         [-39,   65, -112,  -16,  -78,  -72],
    //         [6,  -11,   -6,   62,   49,    8]
    //     ],
    //     [
    //         [-57,   49,  -23,   52, -135,   66],
    //         [-23,  127,  -58,   -5, -118,   64],
    //         [87,  -16,  121,   23,  -41,  -12],
    //         [-19,   29,   35, -148,  -11,   45]
    //     ],
    //     [
    //         [-55, -147, -146,  -31,   55,   60],
    //         [-88,  -45,  -28,   46,  -26, -144],
    //         [-12, -107,  -34,  150,  249,   66],
    //         [11,  -15,  -34,   27,  -78,  -50]
    //     ],
    //     [
    //         [56,   67,  108,    4,    2,  -48],
    //         [58,   67,   89,   32,   32,   -8],
    //         [-42,  -31, -103,  -30,  -23,   -8],
    //         [6,    4,  -26,  -10,   26,   12]
    //     ]
    // ];

    // const h3 = [
    //     [
    //         [-6, -8, -5,  9],
    //         [-7,  9, -6, -8],
    //         [2, -7,  9,  8]
    //     ],
    //     [
    //         [7,  4,  4, -6],
    //         [9,  9,  4, -4],
    //         [-3,  7, -2, -3]
    //     ]
    // ];

    const H1 = deconvolution1D(g1, f1);
    console.log("deconvolution1D(g1, f1) = " + JSON.stringify(H1));
    console.log("H1 = h1 ? " + arraysEqual(H1, h1));
    console.log();

    const F1 = deconvolution1D(g1, h1);
    console.log("deconvolution1D(g1, h1) = " + JSON.stringify(F1));
    console.log("F1 = f1 ? " + arraysEqual(F1, f1));
    console.log();

    // const H2 = deconvolution2D(g2, f2);
    // console.log("deconvolution2D(g2, f2) = " + JSON.stringify(H2));
    // console.log("H2 = h2 ? " + arraysDeepEqual(H2, h2));
    // console.log();

    // const F2 = deconvolution2D(g2, h2);
    // console.log("deconvolution2D(g2, h2) = " + JSON.stringify(F2));
    // console.log("F2 = f2 ? " + arraysDeepEqual(F2, f2));
    // console.log();

    // const H3 = deconvolution3D(g3, f3);
    // console.log("deconvolution3D(g3, f3) = " + JSON.stringify(H3));
    // console.log("H3 = h3 ? " + arraysDeepEqual(H3, h3));
    // console.log();

    // const F3 = deconvolution3D(g3, h3);
    // console.log("deconvolution3D(g3, h3) = " + JSON.stringify(F3));
    // console.log("F3 = f3 ? " + arraysDeepEqual(F3, f3));
}

// Helper functions for array comparison
function arraysEqual(a, b) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
        if (a[i] !== b[i]) return false;
    }
    return true;
}

function arraysDeepEqual(a, b) {
    return JSON.stringify(a) === JSON.stringify(b);
}

// Run the main function
main();
