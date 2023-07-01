function rk4(y, x, dx, f) {
    var k1 = dx * f(x, y),
        k2 = dx * f(x + dx / 2.0,   +y + k1 / 2.0),
        k3 = dx * f(x + dx / 2.0,   +y + k2 / 2.0),
        k4 = dx * f(x + dx,         +y + k3);

    return y + (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0;
}

function f(x, y) {
    return x * Math.sqrt(y);
}

function actual(x) {
    return (1/16) * (x*x+4)*(x*x+4);
}

var y = 1.0,
    x = 0.0,
    step = 0.1,
    steps = 0,
    maxSteps = 101,
    sampleEveryN = 10;

while (steps < maxSteps) {
    if (steps%sampleEveryN === 0) {
        console.log("y(" + x + ") =  \t" + y + "\t ± " + (actual(x) - y).toExponential());
    }

    y = rk4(y, x, step, f);

    // using integer math for the step addition
    // to prevent floating point errors as 0.2 + 0.1 != 0.3
    x = ((x * 10) + (step * 10)) / 10;
    steps += 1;
}
