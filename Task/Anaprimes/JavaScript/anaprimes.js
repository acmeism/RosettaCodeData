function main() {
    const primes = listPrimeNumbers(1_0_001_000);
    const anaprimes = new Map();

    let index = 0;
    let limit = 1_000;

    while (limit <= 1_0_000_000 ) {
        const prime = primes[index++];

        if (prime > limit) {
            let maxLength = 0;
            const groups = [];

            for (const value of anaprimes.values()) {
                if (value.length > maxLength) {
                    groups.length = 0;
                    maxLength = value.length;
                }
                if (value.length === maxLength) {
                    groups.push(value);
                }
            }

            console.log(
                `Largest group(s) of anaprimes less than ${limit} has ${maxLength} members:`
            );
            for (const group of groups) {
                console.log(`    First: ${group[0]}, Last: ${group[group.length - 1]}`);
            }
            console.log();

            anaprimes.clear();
            limit *= 10;
        }

        const key = digits(prime).join(',');
        if (!anaprimes.has(key)) {
            anaprimes.set(key, []);
        }
        anaprimes.get(key).push(prime);
    }
}

function digits(number) {
    const result = [];
    while (number > 0) {
        result.push(number % 10);
        number = Math.floor(number / 10);
    }
    return result.sort((a, b) => a - b);
}

function listPrimeNumbers(limit) {
    const primes = [2];
    const halfLimit = Math.floor((limit + 1) / 2);
    const composite = new Array(halfLimit).fill(false);

    for (let i = 1, p = 3; i < halfLimit; p += 2, i++) {
        if (!composite[i]) {
            primes.push(p);
            for (let a = i + p; a < halfLimit; a += p) {
                composite[a] = true;
            }
        }
    }

    return primes;
}

// Run the program
main();
