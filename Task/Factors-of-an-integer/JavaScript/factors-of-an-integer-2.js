console.log(
  (function (lstTest) {

    // INTEGER FACTORS
    function integerFactors(n) {
      var rRoot = Math.sqrt(n),
        intRoot = Math.floor(rRoot),

        lows = range(1, intRoot).filter(function (x) {
          return (n % x) === 0;
        });

      // for perfect squares, we can drop the head of the 'highs' list
      return lows.concat(lows.map(function (x) {
        return n / x;
      }).reverse().slice((rRoot === intRoot) | 0));
    }

    // [m .. n]
    function range(m, n) {
      return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
        return m + i;
      });
    }

    /*************************** TESTING *****************************/

    // TABULATION OF RESULTS IN SPACED AND ALIGNED COLUMNS
    function alignedTable(lstRows, lngPad, fnAligned) {
      var lstColWidths = range(0, lstRows.reduce(function (a, x) {
        return x.length > a ? x.length : a;
      }, 0) - 1).map(function (iCol) {
        return lstRows.reduce(function (a, lst) {
          var w = lst[iCol] ? lst[iCol].toString().length : 0;
          return (w > a) ? w : a;
        }, 0);
      });

      return lstRows.map(function (lstRow) {
        return lstRow.map(function (v, i) {
          return fnAligned(v, lstColWidths[i] + lngPad);
        }).join('')
      }).join('\n');
    }

    function alignRight(n, lngWidth) {
      var s = n.toString();
      return Array(lngWidth - s.length + 1).join(' ') + s;
    }

    // TEST
    return '\nintegerFactors(n)\n\n' + alignedTable(
      lstTest.map(integerFactors).map(function (x, i) {
        return [lstTest[i], '-->'].concat(x);
      }), 2, alignRight
    ) + '\n';

  })([25, 45, 53, 64, 100, 102, 120, 12345, 32766, 32767])
);
