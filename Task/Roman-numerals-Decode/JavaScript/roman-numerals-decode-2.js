(function (lstTest) {

  var dctGlyphs = {
      'M': 1000,
      'CM': 900,
      'D': 500,
      'CD': 400,
      'C': 100,
      'XC': 90,
      'L': 50,
      'XL': 40,
      'X': 10,
      'IX': 9,
      'V': 5,
      'IV': 4,
      'I': 1
    },
    lstGlyphs = Object.keys(dctGlyphs);

  // s -> {name: [s], value: Int}
  function romanValue(s) {

    function trans(lstChars, lngStart) {
      var lngChars = lstChars.length,
        dctParse = lngChars ? lstGlyphs.reduce(
          function (dctA, strGlyph) {
            return isPrefixOf(strGlyph.split(''), dctA.chars) ? {
              value: dctA.value + dctGlyphs[strGlyph],
              chars: drop(strGlyph.length, dctA.chars)
            } : dctA;
          }, {
            value: lngStart,
            chars: lstChars
          }
        ) : {
          chars: [],
          value: null
        },
        lstRest = dctParse.chars || [],
        lngRest = lstRest.length;

      return lngRest && (lngRest !== lngChars) ? (
        trans(lstRest, dctParse.value)
      ) : dctParse;
    }

    var dctTrans = trans(s.toUpperCase().split(''), 0);

    return dctTrans.chars.length ? null : dctTrans.value;
  }

  // [a] -> [a] -> Bool
  function isPrefixOf(lstFirst, lstSecond) {
    return lstFirst.length ? (
      lstSecond.length ?
      lstFirst[0] === lstSecond[0] && isPrefixOf(
        lstFirst.slice(1), lstSecond.slice(1)
      ) : false
    ) : true;
  }

  // Int -> [a] -> [a]
  function drop(n, lst) {
    return n <= 0 ? lst : (
      lst.length ? drop(n - 1, lst.slice(1)) : []
    );
  }

  return lstTest.map(romanValue);

})(['MCMXC', 'MDCLXVI', 'MMVIII']);
