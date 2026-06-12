// A array is used to represents a Polynomial
// with its coefficients reversed compared to the standard mathematical notation.
// For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1, 2, 3].
function add(one, two) {
    const sum = new Array(Math.max(one.length, two.length)).fill(0.0);
    for (let i = 0; i < one.length; ++i) {
        sum[i] = one[i];
    }
    for (let i = 0; i < two.length; ++i) {
        sum[i] += two[i];
    }
    return sum;
}

function multiply(one, two) {
    const product = new Array(one.length + two.length - 1).fill(0.0);
    for (let i = 0; i < one.length; ++i) {
        for (let j = 0; j < two.length; ++j) {
            product[i + j] += one[i] * two[j];
        }
    }
    return product;
}

function scalar_multiply(vec, value) {
    return vec.map(d => d * value);
}

function scalar_divide(vec, value) {
    return scalar_multiply(vec, 1.0 / value);
}

function evaluate(vec, value) {
    let result = 0.0;
    for (let i = vec.length - 1; i >= 0; --i) {
        result = result * value + vec[i];
    }
    return result;
}

function display(vec) {
    const degree = vec.length - 1;
    if (degree === 0) {
        console.log(vec[0].toFixed(5));
        return;
    }

    let output = "";
    for (let i = degree; i >= 0; i--) {
        if (vec[i] === 0.0) {
            continue;
        }
        const sign = (vec[i] < 0.0 && i === degree) ?
            "-" : (vec[i] < 0.0) ? " - " : (i < degree) ? " + " : "";
        output += sign;
        const coeff = Math.abs(vec[i]);
        if (coeff > 1.0) {
            output += coeff.toFixed(5);
        }
        const term = (i > 1) ? "x^" + i : (i === 1) ?
            "x" : (coeff === 1.0) ? "1" : "";
        output += term;
    }
    console.log(output);
}

class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }
}

function lagrange_interpolation(points) {
    const polys = Array(points.length).fill().map(() => Array(points.length).fill(0.0));
    for (let i = 0; i < points.length; ++i) {
        let poly = [1.0];
        for (let j = 0; j < points.length; ++j) {
            if (i !== j) {
                poly = multiply(poly, [-points[j].x, 1.0]);
            }
        }
        const value = evaluate(poly, points[i].x);
        polys[i] = scalar_divide(poly, value);
    }

    let sum = [0.0];
    for (let i = 0; i < points.length; ++i) {
        polys[i] = scalar_multiply(polys[i], points[i].y);
        sum = add(sum, polys[i]);
    }
    return sum;
}

function main() {
    const points = [new Point(1, 1), new Point(2, 4), new Point(3, 1), new Point(4, 5)];
    display(lagrange_interpolation(points));
}

// Execute the main function
main();
