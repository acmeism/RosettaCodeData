// Chi-squared distribution statistics implementation

// The gamma function using Lanczos approximation
function gamma(aX) {
    if (aX < 0.5) {
        return Math.PI / (Math.sin(Math.PI * aX) * gamma(1.0 - aX));
    }

    const probabilities = [
        0.99999999999980993, 676.5203681218851, -1259.1392167224028, 771.32342877765313, -176.61502916214059,
        12.507343278686905, -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7
    ];

    aX -= 1.0;
    let t = probabilities[0];
    for (let i = 1; i < 9; i++) {
        t += probabilities[i] / (aX + i);
    }

    const w = aX + 7.5;
    return Math.sqrt(2.0 * Math.PI) * Math.pow(w, aX + 0.5) * Math.exp(-w) * t;
}

// The probability density function of the Chi-squared distribution
function pdf(aX, aK) {
    return (aX > 0.0) ?
        Math.pow(aX, aK / 2 - 1) * Math.exp(-aX / 2) / (Math.pow(2, aK / 2) * gamma(aK / 2)) : 0.0;
}

// The normalised lower incomplete gamma function
function gammaCDF(aX, aK) {
    let result = 0.0;
    for (let m = 0; m <= 99; m++) {
        result += Math.pow(aX, m) / gamma(aK + m + 1);
    }
    result *= Math.pow(aX, aK) * Math.exp(-aX);
    return result;
}

// The cumulative probability function of the Chi-squared distribution
function cdf(aX, aK) {
    if (aX > 1000 && aK < 100) {
        return 1.0;
    }
    return (aX > 0.0 && aK > 0.0) ? gammaCDF(aX / 2, aK / 2) : 0.0;
}

// Helper function to format numbers like Java's String.format
function formatNumber(value, width, precision) {
    const formatStr = `%${width}.${precision}f`;
    return formatStr.replace('%', value.toFixed(precision));
}

// Main function demonstrating the Chi-squared distribution calculations
function main() {
    console.log("    Values of the Chi-squared probability distribution function");
    console.log(" x/k     1         2         3         4         5");

    for (let x = 0; x <= 10; x++) {
        let row = x.toString().padStart(2);
        for (let k = 1; k <= 5; k++) {
            row += pdf(x, k).toFixed(6).padStart(10);
        }
        console.log(row);
    }

    console.log();
    console.log("    Values for the Chi-squared distribution with 3 degrees of freedom");
    console.log("Chi-squared   cumulative pdf   p-value");

    const testValues = [1, 2, 4, 8, 16, 32];
    for (const x of testValues) {
        const cdfValue = cdf(x, 3);
        console.log(`${x.toString().padStart(6)}${cdfValue.toFixed(6).padStart(19)}${(1.0 - cdfValue).toFixed(6).padStart(14)}`);
    }

    const observed = [[77, 23], [88, 12], [79, 21], [81, 19]];
    const expected = [[81.25, 18.75], [81.25, 18.75], [81.25, 18.75], [81.25, 18.75]];
    let testStatistic = 0.0;

    for (let i = 0; i < observed.length; i++) {
        for (let j = 0; j < observed[0].length; j++) {
            testStatistic += Math.pow(observed[i][j] - expected[i][j], 2.0) / expected[i][j];
        }
    }

    const degreesFreedom = (observed.length - 1) / (observed[0].length - 1);

    console.log();
    console.log("For the airport data:");
    console.log("    test statistic     : " + testStatistic.toFixed(6));
    console.log("    degrees of freedom : " + degreesFreedom);
    console.log("    Chi-squared        : " + pdf(testStatistic, degreesFreedom).toFixed(6));
    console.log("    p-value            : " + cdf(testStatistic, degreesFreedom).toFixed(6));
}

// Run the main function
main();
