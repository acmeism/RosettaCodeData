const items = [
    ["alliance",     -624],
    ["archbishop",   -915],
    ["balm",          397],
    ["bonnet",        452],
    ["brute",         870],
    ["centipede",    -658],
    ["cobol",         362],
    ["covariate",     590],
    ["departure",     952],
    ["deploy",         44],
    ["diophantine",   645],
    ["efferent",       54],
    ["elysee",       -326],
    ["eradicate",     376],
    ["escritoire",    856],
    ["exorcism",     -983],
    ["fiat",          170],
    ["filmy",        -874],
    ["flatworm",      503],
    ["gestapo",       915],
    ["infra",        -847],
    ["isis",         -982],
    ["lindholm",      999],
    ["markham",       475],
    ["mincemeat",    -880],
    ["moresby",       756],
    ["mycenae",       183],
    ["plugging",     -266],
    ["smokescreen",   423],
    ["speakeasy",    -745],
    ["vein",          813],
];

const indices = new Array(items.length);
let count = 0;
const LIMIT = 5;

function subsum(i, weight) {
    if (i !== 0 && weight === 0) {
        let result = [];
        for (let j = 0; j < i; ++j) {
            const item = items[indices[j]];
            result.push(item[0]);
        }
        console.log(result.join(' '));
        if (count < LIMIT) count++;
        else return;
    }

    const k = (i !== 0) ? indices[i - 1] + 1 : 0;
    for (let j = k; j < items.length; ++j) {
        indices[i] = j;
        subsum(i + 1, weight + items[j][1]);
        if (count === LIMIT) return;
    }
}

// Main function
function main() {
    subsum(0, 0);
}

main();
