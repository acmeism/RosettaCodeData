var lst = [[2, 12, 10, 4], [18, 11, 9, 3], [14, 15, 7, 17], [6, 19, 8, 13], [1,
  20, 16, 5]];

var takeWhile = function (lst, fnTest) {
    'use strict';
    var varHead = lst.length ? lst[0] : null;

    return varHead ? (
      fnTest(varHead) ? [varHead].concat(
        takeWhile(lst.slice(1), fnTest)
      ) : []
    ) : []
  },

  // The takeWhile function terminates when notTwenty(n) returns false
  notTwenty = function (n) {
    return n !== 20;
  },

  // Leftward groups containing no 20
  // takeWhile nested within takeWhile
  lstChecked = takeWhile(lst, function (group) {
    return takeWhile(
      group,
      notTwenty
    ).length === 4;
  });


// Return the trail of numbers preceding 20 from a composable expression

console.log(
  // Numbers before 20 in a group in which it was found
  lstChecked.concat(
    takeWhile(
      lst[lstChecked.length], notTwenty
    )
  )
  // flattened
  .reduce(function (a, x) {
    return a.concat(x);
  }).join('\n')
);
