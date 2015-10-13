function roman(strIntegers) {
  'use strict';
  // DICTIONARY OF GLYPH:VALUE MAPPINGS
  var dctGlyphs = {
    M: 1000,
    CM: 900,
    D: 500,
    CD: 400,
    C: 100,
    XC: 90,
    L: 50,
    XL: 40,
    X: 10,
    IX: 9,
    V: 5,
    IV: 4,
    I: 1
  };

  // LIST OF INTEGER STRINGS, WITH ANY SEPARATOR
  var strNums = typeof strIntegers === 'string' ? strIntegers : strIntegers.toString(),
    lstParts = strNums.split(/\d+/),
    strSeparator = lstParts.length > 1 ? lstParts[1] : '',
    lstDecimal = strSeparator ? strIntegers.split(strSeparator) : [strNums];


  // REWRITE OF DECIMAL INTEGER AS ROMAN
  function rewrite(strN) {
    var n = Number(strN);

    /*  Starting with the highest-valued glyph:
      take as many bites as we can with it
      (decrementing residual value with each bite,
      and appending a corresponding glyph copy to the string)
      before moving down to the next most expensive glyph */

  // return Object.keys(dctGlyphs).reduce(
  // OR:
  return 'M CM D CD C XC L XL X IX V IV I'.split(' ').reduce(
      function (s, k) {
        var v = dctGlyphs[k];
        return n >= v ? (n -= v, s + k) : s;
      }, ''
    )

  }

  // ALL REWRITTEN, WITH SEPARATOR RESTORED
  return lstDecimal.map(rewrite).join(strSeparator);
}
