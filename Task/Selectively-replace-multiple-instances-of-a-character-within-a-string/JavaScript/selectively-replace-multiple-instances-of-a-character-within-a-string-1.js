function findNth(s, c, n) {
  if (n === 1) return s.indexOf(c);
  return s.indexOf(c, findNth(s, c, n - 1) + 1);
}

function selectiveReplace(s, ops) {
  const chars = Array.from(s);
  for ([n, old, rep] of ops) {
    chars[findNth(s, old, n)] = rep;
  }
  return chars.join("");
}

console.log(
  selectiveReplace("abracadabra", [
    [1, "a", "A"], // the first 'a' with 'A'
    [2, "a", "B"], // the second 'a' with 'B'
    [4, "a", "C"], // the fourth 'a' with 'C'
    [5, "a", "D"], // the fifth 'a' with 'D'
    [1, "b", "E"], // the first 'b' with 'E'
    [2, "r", "F"], // the second 'r' with 'F'
  ])
);
