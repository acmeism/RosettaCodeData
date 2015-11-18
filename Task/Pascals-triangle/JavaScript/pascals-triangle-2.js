(function (n) {

  // A Pascal triangle of n rows
  // n --> [[n]]
  function pascalTriangle(n) {

    // Sums of each consecutive pair of numbers
    // [n] --> [n]
    function pairSums(lst) {
      return lst.reduce(function (acc, n, i, l) {
        var iPrev = i ? i - 1 : 0;
        return i ? acc.concat(l[iPrev] + l[i]) : acc
      }, []);
    }

    // Next line in a Pascal triangle series
    // [n] --> [n]
    function nextPascal(lst) {
      return lst.length ? [1].concat(
        pairSums(lst)
      ).concat(1) : [1];
    }

    // Each row is a function of the preceding row
    return n ? Array.apply(null, Array(n - 1)).reduce(
      function (a, _, i) {
        return a.concat([nextPascal(a[i])]);
      }, [[1]]) : [];
  }

  // TEST
  var lstTriangle = pascalTriangle(n);


  // FORMAT OUTPUT AS WIKI TABLE

  // [[a]] -> bool -> s -> s
  function wikiTable(lstRows, blnHeaderRow, strStyle) {
    return '{| class="wikitable" ' + (
      strStyle ? 'style="' + strStyle + '"' : ''
    ) + lstRows.map(function (lstRow, iRow) {
      var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|');

      return '\n|-\n' + strDelim + ' ' + lstRow.map(function (v) {
        return typeof v === 'undefined' ? ' ' : v;
      }).join(' ' + strDelim + strDelim + ' ');
    }).join('') + '\n|}';
  }

  var lstLastLine = lstTriangle.slice(-1)[0],
    lngBase = (lstLastLine.length * 2) - 1,
    nWidth = lstLastLine.reduce(function (a, x) {
      var d = x.toString().length;
      return d > a ? d : a;
    }, 1) * lngBase;

  return [
    wikiTable(
      lstTriangle.map(function (lst) {
        return lst.join(';;').split(';');
      }).map(function (line, i) {
        var lstPad = Array((lngBase - line.length) / 2);
        return lstPad.concat(line).concat(lstPad);
      }),
      false,
      'text-align:center;width:' + nWidth + 'em;height:' + nWidth +
      'em;table-layout:fixed;'
    ),

    JSON.stringify(lstTriangle)
  ].join('\n\n');
})(7);
