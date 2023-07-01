const longest = (xs, ys) => (xs.length > ys.length) ? xs : ys;

const lcs = (xx, yy) => {
  if (!xx.length || !yy.length) { return ''; }

  const [x, ...xs] = xx;
  const [y, ...ys] = yy;

  return (x === y) ? (x + lcs(xs, ys)) : longest(lcs(xx, ys), lcs(xs, yy));
};
