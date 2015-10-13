(function (lstRanges) {

  function cRange(cFrom, cTo) {
    var iStart = cFrom.codePointAt(0);

    return Array.apply(
      null, Array(cTo.codePointAt(0) - iStart + 1)
    ).map(function (_, i) {

      return String.fromCodePoint(iStart + i);

    });
  }

  return lstRanges.map(function (lst) {
    return cRange(lst[0], lst[1]);
  });

})([
  ['a', 'z'],
  ['🐐', '🐟']
]);
