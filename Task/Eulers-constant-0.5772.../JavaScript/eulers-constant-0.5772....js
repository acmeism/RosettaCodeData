function ByVaccaSeries(numTerms) {
    // this method is simple but converges slowly
    // calculate gamma by:
    // 1 * (1/2 - 1/3) +
    // 2 * (1/4 - 1/5 + 1/6 - 1/7) +
    // 3 * (1/8 - 1/9 + 1/10 - 1/11 + 1/12 - 1/13 + 1/14 - 1/15) +
    // 4 * ( . . . ) +
    // . . .
    let gamma = 0;
    let next = 4;
    for (let numerator = 1; numerator < numTerms; ++numerator) {
        let delta = 0;
        for (let denominator = next / 2; denominator < next; denominator += 2) {
            // calculate terms two at a time
            delta += 1.0 / denominator - 1.0 / (denominator + 1);
        }
        gamma += numerator * delta;
        next *= 2;
    }
    return gamma;
}
// based on the C entry
function ByEulersMethod() {
    //Bernoulli numbers with even indices
    const B2 = [1.0, 1.0 / 6, -1.0 / 30, 1.0 / 42, -1.0 / 30,
        5.0 / 66, -691.0 / 2730, 7.0 / 6];
    const n = 10;
    //n-th harmonic number
    const h = (() => // immediately invoked function expression
    {
        let sum = 1;
        for (let k = 2; k <= n; k++) { sum += 1.0 / k; }
        return sum - Math.log(n);
    })();
    //expansion C = -digamma(1)
    let a = -1.0 / (2 * n);
    let r = 1;
    for (let k = 1; k < B2.length; k++) {
        r *= n * n;
        a += B2[k] / (2 * k * r);
    }
    return h + a;
}
console.log("Vacca series:  " + ByVaccaSeries(32).toPrecision(16));
console.log("Eulers method: " + ByEulersMethod().toPrecision(16));
