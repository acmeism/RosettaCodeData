function doWhile(varValue, fnBody, fnTest) {
  'use strict';
  var d = fnBody(varValue); // a transformed value

  return fnTest(d) ? [d].concat(
    doWhile(d, fnBody, fnTest)
  ) : [d];
}

console.log(
  doWhile(0,           // initial value
    function (x) {     // Do body, returning transformed value
      return x + 1;
    },
    function (x) {     // While condition
      return x % 6;
    }
  ).join('\n')
);
