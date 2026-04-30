class JordanPolyaNumbers {
    constructor() {
        this.jordanPolyaSet = new Set();
        this.decompositions = new Map();
    }

    main() {
        this.createJordanPolya();

        const jordanPolyaArray = Array.from(this.jordanPolyaSet).sort((a, b) => a - b);
        const belowHundredMillion = jordanPolyaArray.filter(n => n < 100000000).pop();

        console.log("The first 50 Jordan-Polya numbers:");
        let output = "";
        for (let i = 0; i < 50; i++) {
            output += jordanPolyaArray[i].toString().padStart(5, ' ');
            output += (i % 10 === 9 ? "\n" : "");
        }
        console.log(output);
        console.log();

        console.log(`The largest Jordan-Polya number less than 100 million: ${belowHundredMillion}`);
        console.log();

        for (const i of [800, 1050, 1800, 2800, 3800]) {
            const number = jordanPolyaArray[i - 1];
            console.log(`The ${i}th Jordan-Polya number is: ${number} = ${this.toString(this.decompositions.get(number))}`);
        }
    }

    createJordanPolya() {
        this.jordanPolyaSet.add(1);
        const nextSet = new Set();
        this.decompositions.set(1, new Map());
        let factorial = 1;

        for (let multiplier = 2; multiplier <= 20; multiplier++) {
            factorial *= multiplier;

            for (const num of this.jordanPolyaSet) {
                let number = num;
                while (number <= Number.MAX_SAFE_INTEGER / factorial) {
                    const original = number;
                    number *= factorial;
                    nextSet.add(number);

                    // Copy the decomposition from original
                    const newDecomp = new Map(this.decompositions.get(original));
                    this.decompositions.set(number, newDecomp);

                    // Merge: increment the count for this multiplier
                    const currentCount = newDecomp.get(multiplier) || 0;
                    newDecomp.set(multiplier, currentCount + 1);
                }
            }

            for (const num of nextSet) {
                this.jordanPolyaSet.add(num);
            }
            nextSet.clear();
        }
    }

    toString(map) {
        let result = "";
        const keys = Array.from(map.keys()).sort((a, b) => a - b);

        for (const key of keys) {
            const value = map.get(key);
            result = `${key}!${value === 1 ? '' : '^' + value} * ${result}`;
        }

        return result.substring(0, result.length - 3);
    }
}

// Run the program
const jp = new JordanPolyaNumbers();
jp.main();
