(function (n) {

  // Spiral: the first row plus a smaller spiral rotated 90 degrees clockwise
  function spiral(lngRows, lngCols, nStart) {
    return lngRows ? [range(nStart, (nStart + lngCols) - 1)].concat(
      transpose(
        spiral(lngCols, lngRows - 1, nStart + lngCols)
      ).map(reverse)
    ) : [
      []
    ];
  }

  // rows and columns transposed (for 90 degree rotation)
  function transpose(lst) {
    return lst.length > 1 ? lst[0].map(function (_, col) {
      return lst.map(function (row) {
        return row[col];
      });
    }) : lst;
  }

  // elements in reverse order (for 90 degree rotation)
  function reverse(lst) {
    return lst.length > 1 ? lst.reduceRight(function (acc, x) {
      return acc.concat(x);
    }, []) : lst;
  }

  // [m..n]
  function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
      return m + i;
    });
  }

  // TESTING

  var lstSpiral = spiral(n, n, 0);


  // OUTPUT FORMATTING - JSON and wikiTable
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

  return [
    wikiTable(

      lstSpiral,

      false,
      'text-align:center;width:12em;height:12em;table-layout:fixed;'
    ),

    JSON.stringify(lstSpiral)
  ].join('\n\n');

})(5);
