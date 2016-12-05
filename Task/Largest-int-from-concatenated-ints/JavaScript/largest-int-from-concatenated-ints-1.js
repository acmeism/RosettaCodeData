 (function () {
     'use strict';

     // maxCombine :: [Int] -> Int
     function maxCombine(xs) {
         return parseInt(
             xs.sort(
                 function (x, y) {
                     var a = x.toString(),
                         b = y.toString(),
                         ab = parseInt(a + b),
                         ba = parseInt(b + a);

                     return ab > ba ? -1 : (ab < ba ? 1 : 0);
                 }
             )
             .join(''), 10
         );
     }

     return [
        [1, 34, 3, 98, 9, 76, 45, 4],
        [54, 546, 548, 60]
     ].map(maxCombine);

 })();
