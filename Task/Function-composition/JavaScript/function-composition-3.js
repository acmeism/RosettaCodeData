(function () {
    'use strict';


    // iterativeComposed :: [f] -> f
    function iterativeComposed(fs) {

        return function (x) {
            var i = fs.length,
                e = x;

            while (i--) e = fs[i](e);
            return e;
        }
    }

    // foldComposed :: [f] -> f
    function foldComposed(fs) {

        return function (x) {
            return fs
                .reduceRight(function (a, f) {
                    return f(a);
                }, x);
        };
    }


    var sqrt = Math.sqrt,

        succ = function (x) {
            return x + 1;
        },

        half = function (x) {
            return x / 2;
        };


    // Testing two different multiple composition ([f] -> f) functions

    return [iterativeComposed, foldComposed]
        .map(function (compose) {

            // both functions compose from right to left
            return compose([half, succ, sqrt])(5);

        });
})();
