(function () {

  // n -> [[n]]
  function magic(n) {
    return n % 2 ? rotation(
      transposed(
        rotation(
          table(n)
        )
      )
    ) : null;
  }

  // [[a]] -> [[a]]
  function rotation(lst) {
    return lst.map(function (row, i) {
      return rotated(
        row, ((row.length + 1) / 2) - (i + 1)
      );
    })
  }

  // [[a]] -> [[a]]
  function transposed(lst) {
    return lst[0].map(function (col, i) {
      return lst.map(function (row) {
        return row[i];
      })
    });
  }

  // [a] -> n -> [a]
  function rotated(lst, n) {
    var lng = lst.length,
      m = (typeof n === 'undefined') ? 1 : (
        n < 0 ? lng + n : (n > lng ? n % lng : n)
      );

    return m ? (
      lst.slice(-m).concat(lst.slice(0, lng - m))
    ) : lst;
  }

  // n -> [[n]]
  function table(n) {
    var rngTop = rng(1, n);

    return rng(0, n - 1).map(function (row) {
      return rngTop.map(function (x) {
        return row * n + x;
      });
    });
  }

  // [m..n]
  function rng(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(
      function (x, i) {
        return m + i;
      });
  }

  /******************** TEST WITH 3, 5, 11 ***************************/

  // Results as right-aligned wiki tables
  function wikiTable(lstRows, blnHeaderRow, strStyle) {
    var css = strStyle ? 'style="' + strStyle + '"' : '';

    return '{| class="wikitable" ' + css + lstRows.map(
      function (lstRow, iRow) {
        var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|'),
          strDbl = strDelim + strDelim;

        return '\n|-\n' + strDelim + ' ' + lstRow.join(' ' + strDbl + ' ');
      }).join('') + '\n|}';
  }

  return [3, 5, 11].map(
    function (n) {
      var w = 2.5 * n;
      return 'magic(' + n + ')\n\n' + wikiTable(
        magic(n), false, 'text-align:center;width:' + w + 'em;height:' + w + 'em;table-layout:fixed;'
      )
    }
  ).join('\n\n')
})();
