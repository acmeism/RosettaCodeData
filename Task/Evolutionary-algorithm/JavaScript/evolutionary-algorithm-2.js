"use strict"
const TARGET = "METHINKS IT IS LIKE A WEASEL";
const GENE_POOL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
const C = 100;
const MUTATION_RATE = 0.3;

function randomIdGenerator(length) {
    return Math.floor(Math.random() * length);
}
function getGene() {
    return GENE_POOL[randomIdGenerator(GENE_POOL.length)];
}

class Parent {
    _arrayLength;
    _genePool;
    _geneGenerator;

    constructor(arrayLength, genePool, geneGenerator) {
        if (typeof arrayLength === 'number' && arrayLength > 0) {
            this._arrayLength = arrayLength;
        }

        if (typeof genePool === 'string' && genePool.length > 0) {
            this._genePool = [...genePool];
        }

        if (typeof geneGenerator === 'function') {
            this._geneGenerator = geneGenerator;
        }
    }
    generate() {
        const letters = [];

        while (letters.length < this._arrayLength) {
            letters.push(this._geneGenerator());
        }

        return letters.join('');
    }
}

function fitness(needle, target) {
    if (needle.length !== target.length) return 0;

    const needleArray = [...needle];
    let count = 0;

    [...target].forEach((item, index) => {
        if (item === needleArray[index]) count++;
    });

    return count;
}

function mutate({ source, mutationRate }) {
    if (typeof source !== 'string' || source.length === 0) return '';
    const sourceLength = source.length;
    const iterations = Math.floor(sourceLength * mutationRate);
    const stringArray = [...source];

    for(let i = 0; i < iterations; i++) {
        const shouldReplace = Boolean(Math.floor(Math.random() * 2));

        if(shouldReplace) {
            const id = randomIdGenerator(sourceLength);
            stringArray[id] = getGene();
        }
    }

    return stringArray.join('');
}

function createMutants(parent, mutantNumber) {
    const mutantArray = [];

    for (let i = 0; i < mutantNumber; i++) {
        const mutant = mutate({source: parent, mutationRate: MUTATION_RATE});

        mutantArray.push(
            {
                mutant,
                fitness: fitness(mutant, TARGET),
            },
        );
    }

    return mutantArray;
}

function helperInit(parentString, parentFitness) {
    const mutant = createMutants(parentString, C)
        .sort( (a,b) => a.fitness - b.fitness ).pop();

    if (mutant.fitness >= parentFitness) {
        return {
            string: mutant.mutant,
            fitness: mutant.fitness,
        };
    }

    return {
        string: parentString,
        fitness: parentFitness,
    };
}

function run() {
    const parent = new Parent(TARGET.length, GENE_POOL, getGene);
    let parentString = parent.generate();
    let parentFitness = fitness(parentString, TARGET);
    let genCount = 0;

    while(parentString !== TARGET) {
        const init = helperInit(parentString, parentFitness);
        parentString = init.string;
        parentFitness = init.fitness;
        console.log(init.string);
        genCount++;
    }

    console.log(`Ended in ${genCount} generations`);
}

run();
