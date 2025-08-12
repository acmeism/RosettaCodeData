// Function to calculate the continued fraction
function calc(func, n) {
    let temp = 0;
    for (; n > 0; --n) {
        const [a, b] = func(n);
        temp = b / (a + temp);
    }
    const [a, b] = func(0);
    return a + temp;
}

// Function to compute coefficients for sqrt(2)
function sqrt2(n) {
    return [n > 0 ? 2 : 1, 1];
}

// Function to compute coefficients for Napier's constant
function napier(n) {
    return [n > 0 ? n : 2, n > 1 ? n - 1 : 1];
}

// Function to compute coefficients for pi
function pi(n) {
    return [n > 0 ? 6 : 3, (2 * n - 1) * (2 * n - 1)];
}

// Main function to execute calculations
function main() {
    console.log(calc(sqrt2, 20));
    console.log(calc(napier, 15));
    console.log(calc(pi, 10000));
}

// Run the main function
main();
