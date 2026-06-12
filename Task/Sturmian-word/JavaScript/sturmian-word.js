// Main execution
function main() {
    const sturmian = sturmianWordRational(13, 21);
    console.log(sturmian + " from rational number 13 / 21");

    console.log(sturmianWordQuadratic(1, 5, -1, 2, 8)
        + " from real number ( √5 - 1 ) / 2, the first 8 letters");

    const fibonacci = fibonacciWord(10);
    console.log("Sturmian word equals Fibonacci word? : "
        + (sturmian === fibonacci.substring(0, sturmian.length)));
}

// Return the Sturmian word for the strictly positive rational number m / n
function sturmianWordRational(m, n) {
    if (m > n) {
        return sturmianWordRational(n, m)
            .split('')
            .map(char => char === '0' ? '1' : '0')
            .join('');
    }

    let sturmian = '';
    let k = 1;

    while ((k * m) % n !== 0) {
        const previousFloor = Math.floor(((k - 1) * m) / n);
        const currentFloor = Math.floor((k * m) / n);
        sturmian += (previousFloor === currentFloor ? '0' : '10');
        k += 1;
    }

    return sturmian;
}

// Return the first 'letterCount' letters of Sturmian word for the strictly positive real number
// ( b * √(a) + m ) / n, where a is not a perfect square
function sturmianWordQuadratic(b, a, m, n, letterCount) {
    const p = [0, 1];
    const q = [1, 0];
    let remainder = (b * Math.sqrt(a) + m) / n;

    for (let i = 1; i <= letterCount; i++) {
        const integerPart = Math.floor(remainder);
        const fractionPart = remainder - integerPart;
        const pn = integerPart * p[p.length - 1] + p[p.length - 2];
        const qn = integerPart * q[q.length - 1] + q[q.length - 2];
        p.push(pn);
        q.push(qn);
        remainder = 1.0 / fractionPart;
    }

    return sturmianWordRational(p[p.length - 1], q[q.length - 1]);
}

// Return the Fibonacci word for the given integer
// @see https://en.wikipedia.org/wiki/Fibonacci_word
function fibonacciWord(number) {
    let previous = '0';
    let result = '01';

    for (let i = 2; i < number; i++) {
        const temp = result;
        result += previous;
        previous = temp;
    }

    return result;
}

// Run the main function
main();
