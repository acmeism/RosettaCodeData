// Parses the input string for the numerators and denominators
function compile(prog, numArr, denArr) {
    let regex = /\s*(\d*)\s*\/\s*(\d*)\s*(.*)/m;
    let result;
    while (result = regex.exec(prog)) {
        numArr.push(result[1]);
        denArr.push(result[2]);
        prog = result[3];
    }
    return [numArr, denArr];
}

// Outputs the result of the compile stage
function dump(numArr, denArr) {
    let output = "";
    for (let i in numArr) {
        output += `${numArr[i]}/${denArr[i]} `;
    }
    return `${output}<br>`;
}

// Step
function step(val, numArr, denArr) {
    let i = 0;
    while (i < denArr.length && val % denArr[i] != 0) i++;
    return numArr[i] * val / denArr[i];
}

// Executes Fractran
function exec(val, i, limit, numArr, denArr) {
    let output = "";
    while (val && i < limit) {
        output += `${i}: ${val}<br>`;
        val = step(val, numArr, denArr);
        i++;
    }
    return output;
}

// Main
// Outputs to DOM (clears and writes at the body tag)
let body = document.body;
let [num, den] = compile("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1", [], []);
body.innerHTML = dump(num, den);
body.innerHTML += exec(2, 0, 15, num, den);
