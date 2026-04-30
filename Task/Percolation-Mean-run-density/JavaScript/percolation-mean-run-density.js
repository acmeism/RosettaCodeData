function runTest(probability, length, runCount) {
    let count = 0.0;
    for (let run = 0; run < runCount; run++) {
        let previousBit = 0;
        let currentLength = length;
        while (currentLength-- > 0) {
            const nextBit = (Math.random() < probability) ? 1 : 0;
            if (previousBit < nextBit) {
                count += 1.0;
            }
            previousBit = nextBit;
        }
    }
    return count / runCount / length;
}

function main() {
    console.log("Running 1000 tests each:\n");
    console.log(" p\tlength\tresult\ttheory\t   difference");

    for (let probability = 0.1; probability <= 0.9; probability += 0.2) {
        const theory = probability * (1.0 - probability);
        let length = 100;
        while (length <= 100000) {
            const result = runTest(probability, length, 1000);
            const difference = result - theory;
            const percentDifference = (difference / theory) * 100;
            console.log(`${probability.toFixed(1)}\t${length.toString().padStart(6)}\t${result.toFixed(4)}\t${theory.toFixed(4)}\t${difference >= 0 ? '+' : ''}${difference.toFixed(4)} (${percentDifference >= 0 ? '+' : ''}${percentDifference.toFixed(2)}%)`);
            length *= 10;
        }
        console.log();
    }
}

main();
