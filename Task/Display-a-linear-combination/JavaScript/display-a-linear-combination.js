function basisify(a) {
  let terms = [];
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== 0) {
      terms.push(`${a[i]}*e(${i+1})`);
    }
  }
  if (terms.length === 0) {
    return "0";
  }
  terms = terms.map(s => s.replace("1*", ""));
  return terms.join(" + ").replace("+ -", "- ");
}

const test_vectors = [[1, 2, 3],
                     [0, 1, 2, 3],
                     [1, 0, 3, 4],
                     [1, 2, 0],
                     [0, 0, 0],
                     [0],
                     [1, 1, 1],
                     [-1, -1, -1],
                     [-1, -2, 0, -3],
                     [-1]];

for (const s of test_vectors.map(basisify)){
  console.log(s);
}
