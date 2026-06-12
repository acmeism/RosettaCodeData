function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

function countdown(numbers, target) {
    if (numbers.length <= 1) {
        return false;
    }

    for (let n0 of numbers) {
        const numbers1 = numbers.filter(n => n !== n0);
        for (let n1 of numbers1) {
            const numbers2 = numbers1.filter(n => n !== n1);
            if (n1 >= n0) {
                let result = n1 + n0;
                let numbersNext = [...numbers2, result];
                if (result === target || countdown(numbersNext, target)) {
                    console.log(`${result} = ${n1} + ${n0}`);
                    return true;
                }

                if (n0 !== 1) {
                    result = n1 * n0;
                    numbersNext = [...numbers2, result];
                    if (result === target || countdown(numbersNext, target)) {
                        console.log(`${result} = ${n1} * ${n0}`);
                        return true;
                    }
                }

                if (n1 !== n0) {
                    result = n1 - n0;
                    numbersNext = [...numbers2, result];
                    if (result === target || countdown(numbersNext, target)) {
                        console.log(`${result} = ${n1} - ${n0}`);
                        return true;
                    }
                }

                if (n0 !== 1 && n1 % n0 === 0) {
                    result = Math.floor(n1 / n0);
                    numbersNext = [...numbers2, result];
                    if (result === target || countdown(numbersNext, target)) {
                        console.log(`${result} = ${n1} / ${n0}`);
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

function main() {
    const allNumbers = [
        1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100
    ];

    shuffle(allNumbers);

    const numberLists = [
        [3, 6, 25, 50, 75, 100],
        [100, 75, 50, 25, 6, 3],
        [8, 4, 4, 6, 8, 9],
        allNumbers.slice(0, 6)
    ];

    const targetList = [952, 952, 594, Math.floor(Math.random() * 899) + 101];

    for (let i = 0; i < targetList.length; i++) {
        console.log("Using : " + JSON.stringify(numberLists[i]));
        console.log("Target: " + targetList[i]);
        const done = countdown(numberLists[i], targetList[i]);
        if (!done) {
            console.log("No solution found");
        }
        console.log();
    }
}

main();
