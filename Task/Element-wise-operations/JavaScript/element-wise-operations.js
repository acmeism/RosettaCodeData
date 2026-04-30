const OPERATIONS = {
    add: (a, b) => a + b,
    sub: (a, b) => a - b,
    mul: (a, b) => a * b,
    div: (a, b) => a / b,
    pow: (a, b) => Math.pow(a, b),
    mod: (a, b) => a % b,
};

function scalarOp(op, matr, scalar) {
    const operation = OPERATIONS[op] || ((a, b) => a);
    const result = matr.map(row => row.map(val => operation(val, scalar)));
    return result;
}

function matrOp(op, matr, scalar) {
    const operation = OPERATIONS[op] || ((a, b) => a);
    const result = matr.map((row, i) =>
        row.map((val, j) =>
            operation(val, scalar[i % scalar.length][j % scalar[i % scalar.length].length])
        )
    );
    return result;
}

function printMatrix(matr) {
    matr.forEach(row => console.log(row.join(', ')));
}

// Example usage:
printMatrix(scalarOp("mul", [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0]
], 3.0));

printMatrix(matrOp("div", [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0]
], [
    [1.0, 2.0],
    [3.0, 4.0]
]));
