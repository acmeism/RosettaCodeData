class Matrix {
    constructor(data) {
        if (data instanceof Matrix) {
            this.data = data.data.map(row => [...row]);
            this.rowCount = data.rowCount;
            this.columnCount = data.columnCount;
        } else if (typeof data === 'number') {
            const rows = data;
            const cols = arguments[1];
            this.rowCount = rows;
            this.columnCount = cols;
            this.data = Array(rows).fill(0).map(() => Array(cols).fill(0));
        } else {
            this.rowCount = data.length;
            this.columnCount = data[0].length;
            this.data = data.map(row => [...row]);
        }
    }

    add(other) {
        if (other.rowCount !== this.rowCount || other.columnCount !== this.columnCount) {
            throw new Error('Incompatible matrix dimensions.');
        }

        const result = new Matrix(this);
        for (let i = 0; i < this.rowCount; i++) {
            for (let j = 0; j < this.columnCount; j++) {
                result.data[i][j] = this.data[i][j] + other.data[i][j];
            }
        }
        return result;
    }

    multiply(other) {
        if (this.columnCount !== other.rowCount) {
            throw new Error('Incompatible matrix dimensions.');
        }

        const result = new Matrix(this.rowCount, other.columnCount);
        for (let i = 0; i < this.rowCount; i++) {
            for (let j = 0; j < other.columnCount; j++) {
                for (let k = 0; k < this.rowCount; k++) {
                    result.data[i][j] += this.data[i][k] * other.data[k][j];
                }
            }
        }
        return result;
    }

    transpose() {
        const result = new Matrix(this.columnCount, this.rowCount);
        for (let i = 0; i < this.rowCount; i++) {
            for (let j = 0; j < this.columnCount; j++) {
                result.data[j][i] = this.data[i][j];
            }
        }
        return result;
    }

    minor(index) {
        const result = new Matrix(this.rowCount, this.columnCount);
        for (let i = 0; i < index; i++) {
            result.setEntry(i, i, 1.0);
        }

        for (let i = index; i < this.rowCount; i++) {
            for (let j = index; j < this.columnCount; j++) {
                result.setEntry(i, j, this.data[i][j]);
            }
        }
        return result;
    }

    column(index) {
        const result = new Matrix(this.rowCount, 1);
        for (let i = 0; i < this.rowCount; i++) {
            result.setEntry(i, 0, this.data[i][index]);
        }
        return result;
    }

    scalarMultiply(value) {
        if (this.columnCount !== 1) {
            throw new Error('Incompatible matrix dimension.');
        }

        const result = new Matrix(this.rowCount, this.columnCount);
        for (let i = 0; i < this.rowCount; i++) {
            result.data[i][0] = this.data[i][0] * value;
        }
        return result;
    }

    unit() {
        if (this.columnCount !== 1) {
            throw new Error('Incompatible matrix dimensions.');
        }

        const magnitude = this.magnitude();
        const result = new Matrix(this.rowCount, this.columnCount);
        for (let i = 0; i < this.rowCount; i++) {
            result.data[i][0] = this.data[i][0] / magnitude;
        }
        return result;
    }

    magnitude() {
        if (this.columnCount !== 1) {
            throw new Error('Incompatible matrix dimensions.');
        }

        let norm = 0.0;
        for (let i = 0; i < this.data.length; i++) {
            norm += this.data[i][0] * this.data[i][0];
        }
        return Math.sqrt(norm);
    }

    size() {
        if (this.columnCount !== 1) {
            throw new Error('Incompatible matrix dimensions.');
        }
        return this.rowCount;
    }

    display(title) {
        console.log(title);
        for (let i = 0; i < this.rowCount; i++) {
            let row = '';
            for (let j = 0; j < this.columnCount; j++) {
                row += this.data[i][j].toFixed(4).padStart(9);
            }
            console.log(row);
        }
        console.log();
    }

    getEntry(row, column) {
        return this.data[row][column];
    }

    setEntry(row, column, value) {
        this.data[row][column] = value;
    }

    getRowCount() {
        return this.rowCount;
    }

    getColumnCount() {
        return this.columnCount;
    }
}

function householder(matrix) {
    const rowCount = matrix.getRowCount();
    const columnCount = matrix.getColumnCount();
    const versionsOfQ = [];
    let z = new Matrix(matrix);
    let z1 = new Matrix(rowCount, columnCount);

    for (let k = 0; k < columnCount && k < rowCount - 1; k++) {
        const vectorE = new Matrix(rowCount, 1);
        z1 = z.minor(k);
        const vectorX = z1.column(k);
        let magnitudeX = vectorX.magnitude();

        if (matrix.getEntry(k, k) > 0) {
            magnitudeX = -magnitudeX;
        }

        for (let i = 0; i < vectorE.size(); i++) {
            vectorE.setEntry(i, 0, i === k ? 1 : 0);
        }

        const e = vectorE.scalarMultiply(magnitudeX).add(vectorX).unit();
        versionsOfQ.push(householderFactor(e));
        z = versionsOfQ[k].multiply(z1);
    }

    let Q = versionsOfQ[0];
    for (let i = 1; i < columnCount && i < rowCount - 1; i++) {
        Q = versionsOfQ[i].multiply(Q);
    }

    const R = Q.multiply(matrix);
    Q = Q.transpose();
    return { r: R, q: Q };
}

function householderFactor(vector) {
    if (vector.getColumnCount() !== 1) {
        throw new Error('Incompatible matrix dimensions.');
    }

    const size = vector.size();
    const result = new Matrix(size, size);

    for (let i = 0; i < size; i++) {
        for (let j = 0; j < size; j++) {
            result.setEntry(i, j, -2 * vector.getEntry(i, 0) * vector.getEntry(j, 0));
        }
    }

    for (let i = 0; i < size; i++) {
        result.setEntry(i, i, result.getEntry(i, i) + 1.0);
    }
    return result;
}

function fitPolynomial(x, y, polynomialDegree) {
    const vandermonde = new Matrix(x.getColumnCount(), polynomialDegree + 1);
    for (let i = 0; i < x.getColumnCount(); i++) {
        for (let j = 0; j < polynomialDegree + 1; j++) {
            vandermonde.setEntry(i, j, Math.pow(x.getEntry(0, i), j));
        }
    }
    return leastSquares(vandermonde, y.transpose());
}

function leastSquares(vandermonde, b) {
    const pair = householder(vandermonde);
    return solveUpperTriangular(pair.r, pair.q.transpose().multiply(b));
}

function solveUpperTriangular(r, b) {
    const columnCount = r.getColumnCount();
    const result = new Matrix(columnCount, 1);

    for (let k = columnCount - 1; k >= 0; k--) {
        let total = 0.0;
        for (let j = k + 1; j < columnCount; j++) {
            total += r.getEntry(k, j) * result.getEntry(j, 0);
        }
        result.setEntry(k, 0, (b.getEntry(k, 0) - total) / r.getEntry(k, k));
    }
    return result;
}

// Main execution
const data = [
    [12.0, -51.0, 4.0],
    [6.0, 167.0, -68.0],
    [-4.0, 24.0, -41.0],
    [-1.0, 1.0, 0.0],
    [2.0, 0.0, 3.0]
];

// Task 1
const A = new Matrix(data);
A.display('Initial matrix A:');

const pair = householder(A);
const Q = pair.q;
const R = pair.r;

Q.display('Matrix Q:');
R.display('Matrix R:');

const result = Q.multiply(R);
result.display('Matrix Q * R:');

// Task 2
const x = new Matrix([[0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]]);
const y = new Matrix([[1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0]]);

const polyResult = fitPolynomial(x, y, 2);
polyResult.display('Result of fitting polynomial:');
