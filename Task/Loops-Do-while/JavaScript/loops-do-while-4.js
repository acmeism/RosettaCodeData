function range(m, n) {
  'use strict';
  return Array.apply(null, Array(n - m + 1)).map(
    function (x, i) {
      return m + i;
    }
  );
}

function takeWhile(lst, fnTest) {
 'use strict';
  var varHead = lst.length ? lst[0] : null;

  return varHead ? (
    fnTest(varHead) ? [varHead].concat(
      takeWhile(lst.slice(1), fnTest)
    ) : []
  ) : []
}

console.log(
  takeWhile(
    range(1, 100),
    function (x) {
      return x % 6;
    }
  ).join('\n')
);
