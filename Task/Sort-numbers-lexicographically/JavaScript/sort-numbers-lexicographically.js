function lex_sort(n) {
  let a = [];
  const lims = n > 0 ? [1, n] : [n, 1];
  for (let i = lims[0]; i <= lims[1]; i++) {
    a.push(i);
  }
  return a.toSorted();
}

console.log(lex_sort(13));
