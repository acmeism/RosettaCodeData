function maxdiffs(a) {
  let diffs = [];
  for (let i = 1; i < a.length; i++) {
    diffs.push(Math.abs(a[i - 1] - a[i]));
  }
  const mdiff = Math.max(...diffs);
  let inds = [];
  let idx = diffs.indexOf(mdiff);
  while (idx !== -1) {
    inds.push(idx);
    idx = diffs.indexOf(mdiff, idx + 1);
  }
  const out = inds.map(x => `|${a[x]} - ${a[x + 1]}| = `);
  console.log(`${out.join("")}${mdiff}`);
}

maxdiffs([1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3]);
