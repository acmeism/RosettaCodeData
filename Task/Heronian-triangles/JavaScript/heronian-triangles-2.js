(function (n) {

  var chain = function (xs, f) {                  // Monadic bind/chain
      return [].concat.apply([], xs.map(f));
    },

    hArea = function (x, y, z) {
      var s = (x + y + z) / 2,
        a = s * (s - x) * (s - y) * (s - z);
      return a ? Math.sqrt(a) : 0;
    },

    gcd = function (m, n) { return n ? gcd(n, m % n) : m; },

    rng = function (m, n) {
      return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
        return m + i;
      });
    },

    sum = function (a, x) { return a + x; };

  // DEFINING THE SORTED SUB-SET IN TERMS OF A LIST MONAD

  var lstHeron = chain( rng(1, n), function (x) {
          return chain( rng(x, n), function (y) {
          return chain( rng(y, n), function (z) {

        return (
          (x + y > z) &&
          gcd(gcd(x, y), z) === 1 &&            // Primitive.
          (function () {                        // Heronian.
            var a = hArea(x, y, z);
            return a && (a === parseInt(a, 10))
          })()
        ) ? [[x, y, z]] : [];                   // Monadic inject or fail

  })})}).sort(function (a, b) {
    var dArea = hArea.apply(null, a) - hArea.apply(null, b);
    if (dArea) return dArea;
    else {
      var dPerim = a.reduce(sum, 0) - b.reduce(sum, 0);
      return dPerim ? dPerim : (a[2] - b[2]);
    }
  });

  // OUPUT FORMATTED AS TWO WIKITABLES

  var lstColumns = ['Sides Perimeter Area'.split(' ')],
    fnData = function (lst) {
      return [JSON.stringify(lst), lst.reduce(sum, 0), hArea.apply(null, lst)];
    },
    wikiTable = function (lstRows, blnHeaderRow, strStyle) {
      return '{| class="wikitable" ' + (
        strStyle ? 'style="' + strStyle + '"' : ''
      ) + lstRows.map(function (lstRow, iRow) {
        var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|');

        return '\n|-\n' + strDelim + ' ' + lstRow.map(function (v) {
          return typeof v === 'undefined' ? ' ' : v;
        }).join(' ' + strDelim + strDelim + ' ');
      }).join('') + '\n|}';
    };

  return 'Found: ' + lstHeron.length +
    ' primitive Heronian triangles with sides up to ' + n + '.\n\n' +
    '(Showing first 10, sorted by increasing area, ' +
    'perimeter, and longest side)\n\n' +
    wikiTable(
      lstColumns.concat(lstHeron.slice(0, 10).map(fnData)),
      true
    ) + '\n\n' +
    'All primitive Heronian triangles in this range where area = 210\n' +
    '\n(also in order of increasing perimeter and longest side)\n\n' +
    wikiTable(
      lstColumns.concat(lstHeron.filter(function (x) {
        return 210 === hArea.apply(null, x);
      }).map(fnData)),
      true
    ) + '\n\n';

})(200);
