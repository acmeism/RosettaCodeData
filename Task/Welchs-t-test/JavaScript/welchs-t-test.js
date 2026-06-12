// Helper function for the Lanczos approximation of the gamma function
function gamma(x) {
    const constants = [
        0.99999999999980993,
        676.5203681218851,
        -1259.1392167224028,
        771.32342877765313,
        -176.61502916214059,
        12.507343278686905,
        -0.13857109526572012,
        9.9843695780195716e-6,
        1.5056327351493116e-7
    ];

    if (x < 0.5) {
        return Math.PI / (Math.sin(x * Math.PI) * gamma(1.0 - x));
    }

    x -= 1;
    const t = x + 7.5;
    let a = constants[0];
    for (let i = 1; i < constants.length; i++) {
        a += constants[i] / (x + i);
    }
    return a * Math.sqrt(2.0 * Math.PI) * Math.pow(t, x + 0.5) * Math.exp(-t);
}

// Logarithm of the gamma function
function lgamma(x) {
    return Math.log(gamma(x));
}

// Simpson's rule for numerical integration
function simpson(a, b, n, func) {
    const h = (b - a) / n;
    let sum = 0.0;
    for (let i = 0; i < n; i++) {
        const x = a + i * h;
        sum += (func(x) + 4.0 * func(x + h / 2.0) + func(x + h)) / 6.0;
    }
    return sum * h;
}

// Calculate the average of an array
function average(list) {
    return list.reduce((sum, val) => sum + val, 0) / list.length;
}

// Calculate the sample variance of an array
function sampleVariance(list) {
    if (list.length < 2) {
        throw new Error("List must have at least 2 elements");
    }
    const avg = average(list);
    const sum = list.reduce((acc, val) => acc + Math.pow(val - avg, 2), 0);
    return sum / (list.length - 1);
}

// Calculate Welch's t-statistic
function welch(one, two) {
    const temp = sampleVariance(one) / one.length + sampleVariance(two) / two.length;
    return (average(one) - average(two)) / Math.sqrt(temp);
}

// Calculate degrees of freedom for Welch's t-test
function degreesOfFreedom(one, two) {
    const sv1 = sampleVariance(one);
    const sv2 = sampleVariance(two);
    const n1 = one.length;
    const n2 = two.length;
    const numer = Math.pow(sv1 / n1 + sv2 / n2, 2);
    const denom = Math.pow(sv1, 2) / (n1 * n1 * (n1 - 1)) + Math.pow(sv2, 2) / (n2 * n2 * (n2 - 1));
    return numer / denom;
}

// Calculate the p-value for a two-tailed Welch's t-test
function p2Tail(one, two) {
    const dof = degreesOfFreedom(one, two);
    const welchStat = welch(one, two);
    const gamm = Math.exp(lgamma(dof / 2.0) + lgamma(0.5) - lgamma(dof / 2.0 + 0.5));
    const b = dof / (welchStat * welchStat + dof);
    const func = r => Math.pow(r, dof / 2.0 - 1.0) / Math.sqrt(1.0 - r);
    return simpson(0.0, b, 10000, func) / gamm;
}

// Example usage
const list1 = [27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4];
const list2 = [27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4];
const list3 = [17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8];
const list4 = [21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8];
const list5 = [19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0];
const list6 = [28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2];
const list7 = [30.02, 29.99, 30.11, 29.97, 30.01, 29.99];
const list8 = [29.89, 29.93, 29.72, 29.98, 30.02, 29.98];
const listX = [3.0, 4.0, 1.0, 2.1];
const listY = [490.2, 340.0, 433.9];

console.log(p2Tail(list1, list2).toFixed(6));
console.log(p2Tail(list3, list4).toFixed(6));
console.log(p2Tail(list5, list6).toFixed(6));
console.log(p2Tail(list7, list8).toFixed(6));
console.log(p2Tail(listX, listY).toFixed(6));

