(function (lngCols, lngRows) {

  //range(5, 20) --> [5..20]
  //range('a', 'n') --> ['a'..'n']
  function range(m, n) {
    var blnAlpha = typeof m === 'string',
      iFirst = blnAlpha ? m.charCodeAt(0) : m,
      lstInt = Array.apply(
        null,
        Array((blnAlpha ? n.charCodeAt(0) : n) - iFirst + 1)
      ).map(function (x, i) {
        return iFirst + i;
      });

    return blnAlpha ? lstInt.map(
      function (x) {
        return String.fromCharCode(x);
      }
    ) : lstInt;
  }

  // Letter label for first column (last column will be 'Z')
  var strFirstCol = String.fromCharCode('Z'.charCodeAt(0) - (lngCols - 1));

  var lstData = [[''].concat(range(strFirstCol, 'Z'))].concat(
      range(1, lngRows).map(
        function (row) {
          return [row].concat(
            range(1, lngCols).map(
              function () {
                return Math.floor(
                  Math.random() * 9999
                );
              }
            )
          );
        }
      )
    );

  return [
    '<table>',

    '  <thead style = "text-align: right;">',
    '    ' + lstData[0].reduce(
          function (a, s) {
            return a + '<th>' + s + '</th>';
          }, '<tr>'
        ) + '</tr>',
    '  </thead>',

    '  <tbody style = "text-align: right;">',
      lstData.slice(1).map(
        function (row) {
          return '    ' + row.reduce(
            function (a, s) {
              return a + '<td>' + s + '</td>';
            }, '<tr>'
          ) + '</tr>';
        }
      ).join('\n'),
    '  </tbody>',

    '</table>'
  ].join('\n');

})(3, 4); // (3 columns --> [X..Z]), (4 rows --> [1..4])
