const multiplicationTable = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
  [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
  [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
  [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
  [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
  [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
  [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
  [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
  [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
];

const inverse = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

const permutationTable = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
  [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
  [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
  [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
  [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
  [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
  [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
];


function verhoeffChecksum(number, doValidation, doDisplay) {
  if (doDisplay) {
    const calculationType = doValidation ? "Validation" : "Check digit";
    console.log(calculationType + " calculations for " + number + "\n");
    console.log(" i  ni  p[i, ni]  c");
    console.log("-------------------");
  }

  if (!doValidation) {
    number += "0";
  }

  let c = 0;
  const le = number.length - 1;

  for (let i = le; i >= 0; i--) {
    const ni = parseInt(number.charAt(i));
    const pi = permutationTable[(le - i) % 8][ni];
    c = multiplicationTable[c][pi];

    if (doDisplay) {
      console.log(`${String(le - i).padStart(2)}${String(ni).padStart(3)}${String(pi).padStart(8)}${String(c).padStart(6)}\n`);
    }
  }

  if (doDisplay && !doValidation) {
    console.log("inverse[" + c + "] = " + inverse[c] + "\n");
  }

  return doValidation ? c === 0 : inverse[c];
}


function main() {
  const tests = [
    ["236", true],
    ["12345", true],
    ["123456789012", false],
  ];

  for (const test of tests) {
    let object = verhoeffChecksum(test[0], false, test[1]);
    console.log("The check digit for " + test[0] + " is " + object + "\n");

    for (const number of [test[0] + String(object), test[0] + "9"]) {
      object = verhoeffChecksum(number, true, test[1]);
      const result = object ? "correct" : "incorrect";
      console.log("The validation for " + number + " is " + result + ".\n");
    }
  }
}

main();
