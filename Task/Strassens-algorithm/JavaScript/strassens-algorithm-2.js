class Matrix {
    /** @type {number[][]} */
    data;
    /** @type {number} */
    rows;
    /** @type {number} */
    cols;

    /**
     * @param {number[][]} data The matrix data as a 2D array.
     */
    constructor(data) {
        if (!Array.isArray(data) || (data.length > 0 && !Array.isArray(data[0]))) {
             throw new Error("Input data must be a 2D array.");
        }
        // Optional: Deep copy to prevent external modifications
        this.data = data.map(row => [...row]);
        this.rows = data.length;
        this.cols = (this.rows > 0) ? (data[0]?.length ?? 0) : 0; // Handle empty rows gracefully

        // Optional: Validate that all rows have the same length
        if (this.rows > 0) {
            const firstRowLength = this.cols;
            for (let i = 1; i < this.rows; i++) {
                if (data[i].length !== firstRowLength) {
                    throw new Error("All rows in the matrix must have the same length.");
                }
            }
        }
    }

    /** @returns {number} */
    getRows() {
        return this.rows;
    }

    /** @returns {number} */
    getCols() {
        return this.cols;
    }

    /** @param {Matrix} other */
    validateDimensions(other) {
        if (this.getRows() !== other.getRows() || this.getCols() !== other.getCols()) {
            throw new Error("Matrices must have the same dimensions.");
        }
    }

    /** @param {Matrix} other */
    validateMultiplication(other) {
        if (this.getCols() !== other.getRows()) {
            throw new Error(`Cannot multiply matrices: (${this.getRows()}x${this.getCols()}) * (${other.getRows()}x${other.getCols()})`);
        }
    }

    validateSquarePowerOfTwo() {
        if (this.getRows() !== this.getCols()) {
            throw new Error("Matrix must be square for this operation.");
        }
        const n = this.getRows();
        // Check if n is 0 or not a power of two
        // (n & (n - 1)) === 0 checks if n is a power of two (or 0)
        if (n === 0 || (n & (n - 1)) !== 0) {
             throw new Error("Size of matrix must be a power of two for Strassen.");
        }
    }

    /**
     * Adds another matrix to this matrix.
     * @param {Matrix} other The matrix to add.
     * @returns {Matrix} A new matrix representing the sum.
     */
    add(other) {
        this.validateDimensions(other);

        const result_data = Array.from({ length: this.rows }, () => Array(this.cols).fill(0.0));
        for (let i = 0; i < this.rows; ++i) {
            for (let j = 0; j < this.cols; ++j) {
                result_data[i][j] = this.data[i][j] + other.data[i][j];
            }
        }

        return new Matrix(result_data);
    }

    /**
     * Subtracts another matrix from this matrix.
     * @param {Matrix} other The matrix to subtract.
     * @returns {Matrix} A new matrix representing the difference.
     */
    subtract(other) {
        this.validateDimensions(other);

        const result_data = Array.from({ length: this.rows }, () => Array(this.cols).fill(0.0));
        for (let i = 0; i < this.rows; ++i) {
            for (let j = 0; j < this.cols; ++j) {
                result_data[i][j] = this.data[i][j] - other.data[i][j];
            }
        }

        return new Matrix(result_data);
    }

    /**
     * Multiplies this matrix by another matrix (standard algorithm).
     * @param {Matrix} other The matrix to multiply by.
     * @returns {Matrix} A new matrix representing the product.
     */
    multiply(other) {
        this.validateMultiplication(other);

        const result_data = Array.from({ length: this.rows }, () => Array(other.cols).fill(0.0));
        for (let i = 0; i < this.rows; ++i) {
            for (let j = 0; j < other.cols; ++j) {
                let sum = 0.0;
                // K loops through columns of 'this' and rows of 'other'
                for (let k = 0; k < this.cols; ++k) {
                    sum += this.data[i][k] * other.data[k][j];
                }
                result_data[i][j] = sum;
            }
        }

        return new Matrix(result_data);
    }

    /**
     * Returns a string representation of the matrix.
     * @returns {string}
     */
    toString() {
        return this.data.map(row => `[${row.join(', ')}]`).join('\n');
    }

    /**
     * Returns a string representation with specified precision, handling rounding and "-0".
     * @param {number} p Precision (number of decimal places).
     * @returns {string}
     */
    toStringWithPrecision(p) {
        let resultString = "";
        const pow = Math.pow(10, p);
        const zeroString = (0).toFixed(p);
        const negZeroString = `-${zeroString}`;

        for (const row of this.data) {
            resultString += "[";
            for (let i = 0; i < row.length; ++i) {
                let val = row[i];
                // Round like C++: round(val * 10^p) / 10^p
                let roundedVal = Math.round(val * pow) / pow;

                // Format to fixed precision
                let formattedVal = roundedVal.toFixed(p);

                // Handle the "-0.00..." case that toFixed might produce after rounding
                if (formattedVal === negZeroString) {
                    formattedVal = zeroString;
                }

                resultString += formattedVal;
                if (i < row.length - 1) {
                    resultString += ", ";
                }
            }
            resultString += "]\n"; // Add newline after each row like C++ example
        }
        return resultString.trimEnd(); // Remove trailing newline
    }

    /**
     * Helper function to get quadrant slicing parameters.
     * @param {number} r Half rows
     * @param {number} c Half columns
     * @returns {number[][]} Array of [startRow, endRow, startCol, endCol, offsetRow, offsetCol]
     */
    static params(r, c) {
        // [startRow, endRow, startCol, endCol, resultOffsetRow, resultOffsetCol]
        return [
            [0, r, 0, c, 0, 0],       // Top-left quadrant (0)
            [0, r, c, 2 * c, 0, c],   // Top-right quadrant (1)
            [r, 2 * r, 0, c, r, 0],   // Bottom-left quadrant (2)
            [r, 2 * r, c, 2 * c, r, c]  // Bottom-right quadrant (3)
        ];
    }

    /**
     * Splits the matrix into four equally sized quadrants.
     * Assumes matrix dimensions are even.
     * @returns {Matrix[]} An array of four matrices [TopLeft, TopRight, BottomLeft, BottomRight].
     */
    toQuarters() {
        const r = this.getRows() / 2;
        const c = this.getCols() / 2;
        if (!Number.isInteger(r) || !Number.isInteger(c)) {
            throw new Error("Matrix dimensions must be even for splitting into quarters.");
        }
        const p = Matrix.params(r, c);
        const quarters = Array(4); // Will hold 4 Matrix objects

        for (let k = 0; k < 4; ++k) {
            const q_data = Array.from({ length: r }, () => Array(c));
            const [startRow, endRow, startCol, endCol, offsetRow, offsetCol] = p[k];
            for (let i = startRow; i < endRow; ++i) {
                for (let j = startCol; j < endCol; ++j) {
                    // Adjust indices for the smaller quarter matrix
                    q_data[i - offsetRow][j - offsetCol] = this.data[i][j];
                }
            }
            quarters[k] = new Matrix(q_data);
        }
        return quarters; // [TopLeft, TopRight, BottomLeft, BottomRight]
    }

    /**
     * Creates a new matrix by combining four quadrant matrices.
     * @param {Matrix[]} q An array of four matrices [TopLeft, TopRight, BottomLeft, BottomRight].
     * @returns {Matrix} The combined matrix.
     */
    static fromQuarters(q) {
        if (q.length !== 4) throw new Error("Requires exactly four quadrant matrices.");
        // Basic validation: Ensure quadrants have compatible dimensions
        const r = q[0].getRows();
        const c = q[0].getCols();
        if (q[1].getRows() !== r || q[1].getCols() !== c ||
            q[2].getRows() !== r || q[2].getCols() !== c ||
            q[3].getRows() !== r || q[3].getCols() !== c) {
            throw new Error("Quadrant matrices must have the same dimensions.");
        }

        const p = Matrix.params(r, c);
        const rows = r * 2;
        const cols = c * 2;
        const m_data = Array.from({ length: rows }, () => Array(cols));

        for (let k = 0; k < 4; ++k) {
            const [startRow, endRow, startCol, endCol, offsetRow, offsetCol] = p[k];
            for (let i = startRow; i < endRow; ++i) {
                for (let j = startCol; j < endCol; ++j) {
                    // Adjust indices to read from the correct quadrant
                     m_data[i][j] = q[k].data[i - offsetRow][j - offsetCol];
                }
            }
        }
        return new Matrix(m_data);
    }

    /**
     * Multiplies this matrix by another using Strassen's algorithm.
     * Assumes both matrices are square and their size is a power of two.
     * @param {Matrix} other The matrix to multiply by.
     * @returns {Matrix} The resulting matrix product.
     */
    strassen(other) {
        this.validateSquarePowerOfTwo();
        other.validateSquarePowerOfTwo();
         if (this.getRows() !== other.getRows()) { // Columns already checked by validateSquarePowerOfTwo
             throw new Error("Matrices must be square and of equal size for Strassen multiplication.");
         }

        // Base case: If the matrix is 1x1
        if (this.getRows() === 1) {
            // Use standard multiplication for the 1x1 case
            return this.multiply(other);
        }

        // Split matrices into quarters
        const qa = this.toQuarters(); // [a11, a12, a21, a22]
        const qb = other.toQuarters(); // [b11, b12, b21, b22]

        // Calculate the 7 products recursively (P1 to P7)
        const p1 = (qa[1].subtract(qa[3])).strassen(qb[2].add(qb[3])); // p1 = (a12 - a22) * (b21 + b22)
        const p2 = (qa[0].add(qa[3])).strassen(qb[0].add(qb[3]));       // p2 = (a11 + a22) * (b11 + b22)
        const p3 = (qa[0].subtract(qa[2])).strassen(qb[0].add(qb[1])); // p3 = (a11 - a21) * (b11 + b12)
        const p4 = (qa[0].add(qa[1])).strassen(qb[3]);                   // p4 = (a11 + a12) * b22
        const p5 = qa[0].strassen(qb[1].subtract(qb[3]));               // p5 = a11 * (b12 - b22)
        const p6 = qa[3].strassen(qb[2].subtract(qb[0]));               // p6 = a22 * (b21 - b11)
        const p7 = (qa[2].add(qa[3])).strassen(qb[0]);                   // p7 = (a21 + a22) * b11

        // Calculate the result quarters (C11, C12, C21, C22)
        const c11 = p1.add(p2).subtract(p4).add(p6);
        const c12 = p4.add(p5);
        const c21 = p6.add(p7);
        const c22 = p2.subtract(p3).add(p5).subtract(p7);

        // Combine the quarters into the result matrix
        return Matrix.fromQuarters([c11, c12, c21, c22]);
    }
}

// --- Main execution (equivalent to C++ main) ---
function main() {
    const a = new Matrix([[1.0, 2.0], [3.0, 4.0]]);
    const b = new Matrix([[5.0, 6.0], [7.0, 8.0]]);
    const c = new Matrix([[1.0, 1.0, 1.0, 1.0], [2.0, 4.0, 8.0, 16.0], [3.0, 9.0, 27.0, 81.0], [4.0, 16.0, 64.0, 256.0]]);
    const d = new Matrix([[4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0], [-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0], [3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0], [-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0]]);
    const e = new Matrix([[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0], [9.0, 10.0, 11.0, 12.0], [13.0, 14.0, 15.0, 16.0]]);
    const f = new Matrix([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]]); // Identity Matrix

    console.log("Using 'normal' matrix multiplication:");
    console.log(`  a * b = \n${a.multiply(b).toString()}`);
    console.log(`\n  c * d = \n${c.multiply(d).toStringWithPrecision(6)}`); // Should be close to identity
    console.log(`\n  e * f = \n${e.multiply(f).toString()}`); // Should be e

    console.log("\nUsing 'Strassen' matrix multiplication:");
     try {
        console.log(`  a * b = \n${a.strassen(b).toString()}`);
        console.log(`\n  c * d = \n${c.strassen(d).toStringWithPrecision(6)}`); // Should be close to identity
        console.log(`\n  e * f = \n${e.strassen(f).toString()}`); // Should be e
    } catch (error) {
        console.error("Strassen multiplication failed:", error.message);
    }
}

// Run the main function
main();
