import { readFileSync } from 'node:fs';

const words = readFileSync('unixdict.txt', { encoding: 'utf-8' })
    .split('\n')
    .filter(word => word.length > 10)
    .map(word => ({ word, wordWithoutVowels: word.replaceAll(/[aeiou]/g, '') }))
    .map(data => ({ ...data, numUniqueConsonants: new Set(data.wordWithoutVowels).size }))
    .filter(({ wordWithoutVowels, numUniqueConsonants }) => wordWithoutVowels.length === numUniqueConsonants);

const groupedWords = groupBy(words, ({ numUniqueConsonants }) => numUniqueConsonants);

const countsDescending = Array.from(groupedWords.keys()).sort((a, b) => b - a);

for (const count of countsDescending) {
    const words = groupedWords.get(count)!.map(data => data.word);
    const output = words.length <= 30 ? words.join(' ') : `${words.length} words`;
    console.log(`${count}: ${output}`);
}

function groupBy<T, Group>(items: T[], getGroup: (item: T) => Group) {
    const result = new Map<Group, T[]>();

    for (const item of items) {
        const group = getGroup(item);

        let array = result.get(group);
        if (!array) {
            array = [];
            result.set(group, array);
        }

        array.push(item);
    }

    return result;
}
