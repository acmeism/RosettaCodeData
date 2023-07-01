console.log(function () {

  var lstSuffix = 'th st nd rd th th th th th th'.split(' '),

    fnOrdinalForm = function (n) {
      return n.toString() + (
        11 <= n % 100 && 13 >= n % 100 ?
        "th" : lstSuffix[n % 10]
      );
    },

    range = function (m, n) {
      return Array.apply(
        null, Array(n - m + 1)
      ).map(function (x, i) {
        return m + i;
      });
    };

  return [[0, 25], [250, 265], [1000, 1025]].map(function (tpl) {
    return range.apply(null, tpl).map(fnOrdinalForm).join(' ');
  }).join('\n\n');

}());
