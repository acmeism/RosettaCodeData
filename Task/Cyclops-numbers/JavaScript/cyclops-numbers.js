// Cyclops Numbers - JavaScript implementation

function main() {
    const cyclops = [];
    const primeCyclops = [];
    const blindPrimeCyclops = [];
    const palindromicPrimeCyclops = [];

    const ranges = [
        [0, 0],
        [101, 909],
        [11011, 99099],
        [1110111, 9990999],
        [111101111, 119101111]
    ];

    for (const range of ranges) {
        for (let i = range[0]; i <= range[1]; i++) {
            const value = String(i);
            if (isCyclopsNumber(value)) {
                cyclops.push(i);
                if (isPrime(i)) {
                    primeCyclops.push(i);
                    if (isBlind(value)) {
                        blindPrimeCyclops.push(i);
                    }
                    if (isPalindromic(value)) {
                        palindromicPrimeCyclops.push(i);
                    }
                }
            }
        }
    }

    console.log("The first 50 Cyclops numbers:");
    for (let i = 0; i < 50; i++) {
        process.stdout.write(String(cyclops[i]).padStart(6) + (i % 10 === 9 ? "\n" : ""));
    }
    console.log();
    let idx = firstIndex(cyclops);
    console.log("The first cyclops number greater than ten million is " +
        cyclops[idx] + " at zero based index " + idx);
    console.log();

    console.log("The first 50 prime Cyclops numbers:");
    for (let i = 0; i < 50; i++) {
        process.stdout.write(String(primeCyclops[i]).padStart(7) + (i % 10 === 9 ? "\n" : ""));
    }
    console.log();
    idx = firstIndex(primeCyclops);
    console.log("The first prime cyclops number greater than ten million is " +
        primeCyclops[idx] + " at zero based index " + idx);
    console.log();

    console.log("The first 50 blind prime Cyclops numbers:");
    for (let i = 0; i < 50; i++) {
        process.stdout.write(String(blindPrimeCyclops[i]).padStart(7) + (i % 10 === 9 ? "\n" : ""));
    }
    console.log();
    idx = firstIndex(blindPrimeCyclops);
    console.log("The first blind prime cyclops number greater than ten million is " +
        blindPrimeCyclops[idx] + " at zero based index " + idx);
    console.log();

    console.log("The first 50 palindromic prime Cyclops numbers:");
    for (let i = 0; i < 50; i++) {
        process.stdout.write(String(palindromicPrimeCyclops[i]).padStart(9) + (i % 10 === 9 ? "\n" : ""));
    }
    console.log();
    idx = firstIndex(palindromicPrimeCyclops);
    console.log("The first palindromic prime cyclops number greater than ten million is " +
        palindromicPrimeCyclops[idx] + " at zero based index " + idx);
    console.log();
}

function firstIndex(numbers) {
    let start = 0;
    let end = numbers.length - 1;

    while (start <= end) {
        const mid = start + Math.floor((end - start) / 2);
        if (numbers[mid] <= 10000000) {
            start = mid + 1;
        } else {
            end = mid - 1;
        }
    }
    return start;
}

function isCyclopsNumber(text) {
    const middleIndex = Math.floor(text.length / 2);
    return text[middleIndex] === '0' && text.indexOf('0') === text.lastIndexOf('0');
}

function isPalindromic(text) {
    for (let i = 0; i < Math.floor(text.length / 2); i++) {
        if (text[i] !== text[text.length - 1 - i]) {
            return false;
        }
    }
    return true;
}

function isBlind(text) {
    const middle = Math.floor(text.length / 2);
    const withoutZero = text.substring(0, middle) + text.substring(middle + 1);
    return isPrime(parseInt(withoutZero, 10));
}

function isPrime(number) {
    if (number < 2) {
        return false;
    }
    if (number % 2 === 0) {
        return number === 2;
    }
    if (number % 3 === 0) {
        return number === 3;
    }
    let k = 5;
    while (k * k <= number) {
        if (number % k === 0) {
            return false;
        }
        k += 2;
        if (number % k === 0) {
            return false;
        }
        k += 4;
    }
    return true;
}

// Run the main function
main();
