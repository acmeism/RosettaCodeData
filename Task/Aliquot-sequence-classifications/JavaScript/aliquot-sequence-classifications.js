// See https://en.wikipedia.org/wiki/Divisor_function
function divisorSum(n) {
    let total = 1n;
    let power = 2n;
    // Deal with powers of 2 first
    for (; n % 2n === 0n; power *= 2n, n /= 2n) {
        total += power;
    }
    // Odd prime factors up to the square root
    for (let p = 3n; p * p <= n; p += 2n) {
        let sum = 1n;
        for (power = p; n % p === 0n; power *= p, n /= p) {
            sum += power;
        }
        total *= sum;
    }
    // If n > 1 then it's prime
    if (n > 1n) {
        total *= n + 1n;
    }
    return total;
}

// See https://en.wikipedia.org/wiki/Aliquot_sequence
function classifyAliquotSequence(n) {
    const limit = 16;
    const terms = new Array(limit);
    terms[0] = n;
    let classification = "non-terminating";
    let length = 1;

    for (let i = 1; i < limit; ++i) {
        ++length;
        terms[i] = divisorSum(terms[i - 1]) - terms[i - 1];

        if (terms[i] === n) {
            classification =
                (i === 1 ? "perfect" : (i === 2 ? "amicable" : "sociable"));
            break;
        }

        let j = 1;
        for (; j < i; ++j) {
            if (terms[i] === terms[i - j]) {
                break;
            }
        }

        if (j < i) {
            classification = (j === 1 ? "aspiring" : "cyclic");
            break;
        }

        if (terms[i] === 0n) {
            classification = "terminating";
            break;
        }
    }

    let output = `${n}: ${classification}, sequence: ${terms[0]}`;
    for (let i = 1; i < length && terms[i] !== terms[i - 1]; ++i) {
        output += ` ${terms[i]}`;
    }
    console.log(output);
}

function main() {
    for (let i = 1n; i <= 10n; ++i) {
        classifyAliquotSequence(i);
    }

    const specialNumbers = [11n, 12n, 28n, 496n, 220n, 1184n, 12496n, 1264460n, 790n, 909n, 562n, 1064n, 1488n];
    for (const i of specialNumbers) {
        classifyAliquotSequence(i);
    }

    classifyAliquotSequence(15355717786080n);
    classifyAliquotSequence(153557177860800n);
}

main();
