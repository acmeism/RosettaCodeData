/**
 * Represents the dimensions of a matrix.
 * @typedef {object} Shape
 * @property {number} rows - Number of rows.
 * @property {number} cols - Number of columns.
 */

/**
 * A matrix implemented as a wrapper around a 2D array.
 */
class Matrix {
    /**
     * Creates a Matrix instance.
     * @param {number[][]} data - A 2D array representing the matrix data.
     */
    constructor(data = []) {
        if (!Array.isArray(data) || (data.length > 0 && !Array.isArray(data[0]))) {
            throw new Error("Matrix data must be a 2D array.");
        }
        // Basic check for consistent row lengths
        if (data.length > 1) {
            const firstLen = data[0].length;
            if (!data.every(row => row.length === firstLen)) {
                 throw new Error("Matrix rows must have consistent lengths.");
            }
        }
        this.data = data;
    }

    /**
     * Gets the dimensions (shape) of the matrix.
     * @returns {Shape} An object with rows and cols properties.
     */
    get shape() {
        const rows = this.data.length;
        const cols = rows > 0 ? this.data[0].length : 0;
        return { rows, cols };
    }

    /**
     * Creates a new Matrix assembled from nested blocks of matrices.
     * @param {Matrix[][]} blocks - A 2D array of Matrix objects.
     * @returns {Matrix} A new Matrix assembled from the blocks.
     * @static
     */
    static block(blocks) {
        const newMatrixData = [];
        for (const hblock of blocks) {
            if (!hblock || hblock.length === 0) continue;
            const numRowsInBlock = hblock[0].shape.rows; // Assume consistent rows within a hblock

            for (let i = 0; i < numRowsInBlock; i++) {
                let newRow = [];
                for (const matrix of hblock) {
                    if (matrix.data[i]) { // Check if row exists
                       newRow = newRow.concat(matrix.data[i]);
                    } else {
                       // Handle potential inconsistencies if needed, maybe throw error or fill?
                       console.warn("Inconsistent row count during block assembly");
                    }
                }
                newMatrixData.push(newRow);
            }
        }
        return new Matrix(newMatrixData);
    }

    /**
     * Performs naive matrix multiplication (dot product).
     * @param {Matrix} b - The matrix to multiply with.
     * @returns {Matrix} The resulting matrix product.
     */
    dot(b) {
        if (!(b instanceof Matrix)) {
             throw new Error("Argument must be a Matrix instance.");
        }
        const aShape = this.shape;
        const bShape = b.shape;

        if (aShape.cols !== bShape.rows) {
            throw new Error(`Matrices incompatible for multiplication: ${aShape.cols} cols != ${bShape.rows} rows`);
        }

        const resultData = [];
        for (let i = 0; i < aShape.rows; i++) {
            resultData[i] = [];
            for (let j = 0; j < bShape.cols; j++) {
                let sum = 0;
                for (let k = 0; k < aShape.cols; k++) {
                    sum += this.data[i][k] * b.data[k][j];
                }
                resultData[i][j] = sum;
            }
        }
        return new Matrix(resultData);
    }

    /**
     * Multiplies this matrix by another matrix (using naive multiplication).
     * Equivalent to Python's __matmul__.
     * @param {Matrix} b - The matrix to multiply with.
     * @returns {Matrix} The resulting matrix product.
     */
    multiply(b) {
        return this.dot(b);
    }

    /**
     * Adds another matrix to this matrix.
     * Equivalent to Python's __add__.
     * @param {Matrix} b - The matrix to add.
     * @returns {Matrix} The resulting matrix sum.
     */
    add(b) {
        if (!(b instanceof Matrix)) {
             throw new Error("Argument must be a Matrix instance.");
        }
        const aShape = this.shape;
        const bShape = b.shape;

        if (aShape.rows !== bShape.rows || aShape.cols !== bShape.cols) {
            throw new Error("Matrices must have the same shape for addition.");
        }

        const resultData = this.data.map((row, i) =>
            row.map((val, j) => val + b.data[i][j])
        );
        return new Matrix(resultData);
    }

    /**
     * Subtracts another matrix from this matrix.
     * Equivalent to Python's __sub__.
     * @param {Matrix} b - The matrix to subtract.
     * @returns {Matrix} The resulting matrix difference.
     */
    subtract(b) {
         if (!(b instanceof Matrix)) {
             throw new Error("Argument must be a Matrix instance.");
        }
        const aShape = this.shape;
        const bShape = b.shape;

        if (aShape.rows !== bShape.rows || aShape.cols !== bShape.cols) {
            throw new Error("Matrices must have the same shape for subtraction.");
        }

        const resultData = this.data.map((row, i) =>
            row.map((val, j) => val - b.data[i][j])
        );
        return new Matrix(resultData);
    }

    /**
     * Helper function to slice the matrix data.
     * @param {number} rowStart - Starting row index (inclusive).
     * @param {number} rowEnd - Ending row index (exclusive).
     * @param {number} colStart - Starting column index (inclusive).
     * @param {number} colEnd - Ending column index (exclusive).
     * @returns {Matrix} A new Matrix containing the sliced data.
     * @private // Indicates intended internal use
     */
    _slice(rowStart, rowEnd, colStart, colEnd) {
        const slicedData = this.data.slice(rowStart, rowEnd)
                             .map(row => row.slice(colStart, colEnd));
        return new Matrix(slicedData);
    }

    /**
     * Performs matrix multiplication using Strassen's algorithm.
     * Requires square matrices whose dimensions are powers of 2.
     * @param {Matrix} b - The matrix to multiply with.
     * @returns {Matrix} The resulting matrix product.
     */
    strassen(b) {
        if (!(b instanceof Matrix)) {
             throw new Error("Argument must be a Matrix instance.");
        }
        const aShape = this.shape;
        const bShape = b.shape;

        if (aShape.rows !== aShape.cols) {
            throw new Error("Matrix must be square for Strassen's algorithm.");
        }
        if (aShape.rows !== bShape.rows || aShape.cols !== bShape.cols) {
            throw new Error("Matrices must have the same shape for Strassen's algorithm.");
        }
        // Check if dimension is a power of 2
        if (aShape.rows === 0 || (aShape.rows & (aShape.rows - 1)) !== 0) {
             throw new Error("Matrix dimension must be a power of 2 for Strassen's algorithm.");
        }

        if (aShape.rows === 1) {
            return this.dot(b); // Base case
        }

        const n = aShape.rows;
        const p = n / 2; // Partition size

        // Partition matrices
        const a11 = this._slice(0, p, 0, p);
        const a12 = this._slice(0, p, p, n);
        const a21 = this._slice(p, n, 0, p);
        const a22 = this._slice(p, n, p, n);

        const b11 = b._slice(0, p, 0, p);
        const b12 = b._slice(0, p, p, n);
        const b21 = b._slice(p, n, 0, p);
        const b22 = b._slice(p, n, p, n);

        // Recursive calls (Strassen's 7 multiplications)
        const m1 = (a11.add(a22)).strassen(b11.add(b22));
        const m2 = (a21.add(a22)).strassen(b11);
        const m3 = a11.strassen(b12.subtract(b22));
        const m4 = a22.strassen(b21.subtract(b11));
        const m5 = (a11.add(a12)).strassen(b22);
        const m6 = (a21.subtract(a11)).strassen(b11.add(b12));
        const m7 = (a12.subtract(a22)).strassen(b21.add(b22));

        // Combine results
        const c11 = m1.add(m4).subtract(m5).add(m7);
        const c12 = m3.add(m5);
        const c21 = m2.add(m4);
        const c22 = m1.subtract(m2).add(m3).add(m6);

        // Assemble the final matrix from blocks
        return Matrix.block([[c11, c12], [c21, c22]]);
    }

    /**
     * Rounds the elements of the matrix to a specified number of decimal places.
     * @param {number} [ndigits=0] - Number of decimal places to round to. If undefined or 0, rounds to the nearest integer.
     * @returns {Matrix} A new Matrix with rounded elements.
     */
    round(ndigits = 0) {
        const factor = Math.pow(10, ndigits);
        const roundFn = ndigits > 0
            ? (num) => Math.round((num + Number.EPSILON) * factor) / factor
            : (num) => Math.round(num);

        const roundedData = this.data.map(row =>
            row.map(val => roundFn(val))
        );
        return new Matrix(roundedData);
    }

     /**
     * Provides a string representation of the matrix.
     * @returns {string} The string representation.
     */
    toString() {
        const rowsStr = this.data.map(row => `  [${row.join(', ')}]`);
        return `Matrix([\n${rowsStr.join(',\n')}\n])`;
    }
}

// --- Examples ---

function examples() {
    const a = new Matrix([
        [1, 2],
        [3, 4],
    ]);
    const b = new Matrix([
        [5, 6],
        [7, 8],
    ]);
    const c = new Matrix([
        [1, 1, 1, 1],
        [2, 4, 8, 16],
        [3, 9, 27, 81],
        [4, 16, 64, 256],
    ]);
    const d = new Matrix([
        [4, -3, 4 / 3, -1 / 4],
        [-13 / 3, 19 / 4, -7 / 3, 11 / 24],
        [3 / 2, -2, 7 / 6, -1 / 4],
        [-1 / 6, 1 / 4, -1 / 6, 1 / 24],
    ]);
    const e = new Matrix([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16],
    ]);
    const f = new Matrix([ // Identity matrix
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
    ]);

    console.log("Naive matrix multiplication:");
    console.log(`  a * b = ${a.multiply(b)}`); // Uses toString implicitly
    console.log(`  c * d = ${c.multiply(d).round(2)}`); // Round near-zero elements
    console.log(`  e * f = ${e.multiply(f)}`);

    console.log("\nStrassen's matrix multiplication:");
    console.log(`  a * b = ${a.strassen(b)}`);
    console.log(`  c * d = ${c.strassen(d).round(2)}`); // Round near-zero elements
    console.log(`  e * f = ${e.strassen(f)}`);

    // Example of addition/subtraction
    console.log("\nAddition/Subtraction:");
    const sum_ab = a.add(b);
    console.log(`  a + b = ${sum_ab}`);
    const diff_ba = b.subtract(a);
    console.log(`  b - a = ${diff_ba}`);

    // Example of block creation (creates a 4x4 matrix from four 2x2 matrices)
    console.log("\nBlock Creation:");
    const blocked = Matrix.block([[a, b], [b, a]]);
    console.log(`  Blocked [a,b],[b,a] = ${blocked}`);

}

// Run examples
examples();
