const fs = require('fs');

class StringDistance {
    constructor(word, distance) {
        this.word = word;
        this.distance = distance;
    }
}

function jaroWinklerDistance(string1, string2) {
    let len1 = string1.length;
    let len2 = string2.length;
    if (len1 < len2) {
        [string1, string2] = [string2, string1];
        [len1, len2] = [len2, len1];
    }
    if (len2 === 0) return len1 === 0 ? 0.0 : 1.0;

    const delta = Math.max(1, Math.floor(len1 / 2)) - 1;
    const flag = new Array(len2).fill(false);
    const ch1Match = new Array(len1);
    let matches = 0;

    for (let i = 0; i < len1; ++i) {
        const ch1 = string1.charAt(i);
        for (let j = 0; j < len2; ++j) {
            const ch2 = string2.charAt(j);
            if (j <= i + delta && j + delta >= i && ch1 === ch2 && !flag[j]) {
                flag[j] = true;
                ch1Match[matches++] = ch1;
                break;
            }
        }
    }

    if (matches === 0) return 1.0;

    let transpositions = 0;
    for (let i = 0, j = 0; j < len2; ++j) {
        if (flag[j]) {
            if (string2.charAt(j) !== ch1Match[i]) ++transpositions;
            ++i;
        }
    }

    const m = matches;
    const jaro = (m / len1 + m / len2 + (m - transpositions / 2.0) / m) / 3.0;

    let commonPrefix = 0;
    len2 = Math.min(4, len2);
    for (let i = 0; i < len2; ++i) {
        if (string1.charAt(i) === string2.charAt(i)) ++commonPrefix;
    }

    return 1.0 - (jaro + commonPrefix * 0.1 * (1.0 - jaro));
}

function withinDistance(words, maxDistance, string, max) {
    const result = [];
    for (const word of words) {
        const distance = jaroWinklerDistance(word, string);
        if (distance <= maxDistance) {
            result.push(new StringDistance(word, distance));
        }
    }
    result.sort((a, b) => a.distance - b.distance);
    if (result.length > max) {
        return result.slice(0, max);
    }
    return result;
}

function loadDictionary(path) {
    const data = fs.readFileSync(path, 'utf8');
    return data.split('\n').filter(word => word.trim() !== '');
}

function main() {
    try {
        const words = loadDictionary('linuxwords.txt');
        const strings = [
            "accomodate", "definately", "goverment", "occured",
            "publically", "recieve", "seperate", "untill", "wich"
        ];
        for (const string of strings) {
            console.log(`Close dictionary words (distance < 0.15 using Jaro-Winkler distance) to '${string}' are:`);
            console.log("        Word   |  Distance");
            for (const s of withinDistance(words, 0.15, string, 5)) {
                console.log(`${s.word.padStart(14)} | ${s.distance.toFixed(4)}`);
            }
            console.log();
        }
    } catch (e) {
        console.error(e);
    }
}

main();
