const limit = 1000000;

let divisorSum = new Array(limit + 1).fill(1);
let divisorCount = new Array(limit + 1).fill(1);

for (let index = 2; index <= limit / 2; index++) {
    for (let number = 2 * index; number <= limit; number += index) {
        if (divisorSum[number] === number) {
            console.log(
                `${number.toString().padStart(8, ' ')} equals the sum of its first ` +
                `${divisorCount[number].toString().padStart(3, ' ')} divisors`
            );
        }

        divisorSum[number] += index;
        divisorCount[number]++;
    }
}
