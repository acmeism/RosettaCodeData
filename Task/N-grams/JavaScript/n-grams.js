function findNgrams(text, letterCount) {
    const ngrams = new Map();
    for (let i = 0; i <= text.length - letterCount; i++) {
        const ngram = text.substring(i, i + letterCount);
        ngrams.set(ngram, (ngrams.get(ngram) || 0) + 1);
    }
    return sort(ngrams);
}

function sort(map) {
    return new Map([...map.entries()].sort((one, two) => {
        const comparison = two[1] - one[1];
        return (comparison === 0) ? one[0].localeCompare(two[0]) : comparison;
    }));
}

function main() {
    const text = "Live and let live".toUpperCase();
    for (const letterCount of [2, 3, 4]) {
        const ngrams = findNgrams(text, letterCount);
        console.log(`All ${letterCount}-grams of ${text} and their frequencies:`);
        for (const [key, value] of ngrams.entries()) {
            console.log(`("${key}" : ${value})`);
        }
        console.log();
    }
}

main();
