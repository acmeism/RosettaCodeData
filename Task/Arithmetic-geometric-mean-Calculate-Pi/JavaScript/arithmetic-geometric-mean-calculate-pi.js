const Decimal = require('decimal.js');

// Set global precision (e.g., 512 digits)
Decimal.set({ precision: 512 });

const bigTwo = new Decimal(2);
const bigFour = new Decimal(4);

function bigSqrt(bd) {
    let x0 = new Decimal(0);
    let x1 = new Decimal(Math.sqrt(bd.toNumber()));
    while (!x0.equals(x1)) {
        x0 = x1;
        x1 = bd.div(x0).plus(x0).div(bigTwo);
    }
    return x1;
}

function calculatePi() {
    let a = new Decimal(1);
    let g = a.div(bigSqrt(bigTwo));
    let t;
    let sum = new Decimal(0);
    let pow = bigTwo;

    while (!a.equals(g)) {
        t = a.plus(g).div(bigTwo);
        g = bigSqrt(a.times(g));
        a = t;
        pow = pow.times(bigTwo);
        sum = sum.plus(a.times(a).minus(g.times(g)).times(pow));
    }

    const pi = bigFour.times(a.times(a)).div(new Decimal(1).minus(sum));
    console.log(pi.toString());
}

calculatePi();
