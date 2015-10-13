var longest = (xs, ys) => (xs.length > ys.length) ? xs : ys;

var lcs = (xx, yy) => {
  if (!xx.length || !yy.length) { return ''; }

  var x = xx[0],
      y = yy[0];
  xs = xx.slice(1);
  ys = yy.slice(1);

  return (x === y) ? lcs(xs, ys) :
                     longest(lcs(xx, ys), lcs(xs, yy));
};
