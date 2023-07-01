function loopWhile(varValue, fnDelta, fnTest) {
  'use strict';
  var d = fnDelta(varValue);

  return fnTest(d) ? [d].concat(
    loopWhile(d, fnDelta, fnTest)
  ) : [];
}

console.log(
  loopWhile(
    1024,
    function (x) {
      return Math.floor(x/2);
    },
    function (x) {
      return x > 0;
    }
  ).join('\n')
);
