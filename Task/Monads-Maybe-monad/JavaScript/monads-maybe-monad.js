(function () {
    'use strict';

    // START WITH SOME SIMPLE (UNSAFE) PARTIAL FUNCTIONS:

    // Returns Infinity if n === 0
    function reciprocal(n) {
        return 1 / n;
    }

    // Returns NaN if n < 0
    function root(n) {
        return Math.sqrt(n);
    }

    // Returns -Infinity if n === 0
    // Returns NaN if n < 0
    function log(n) {
        return Math.log(n);
    }


    // NOW DERIVE SAFE VERSIONS OF THESE SIMPLE FUNCTIONS:
    // These versions use a validity test, and return a wrapped value
    // with a boolean .isValid property as well as a .value property

    function safeVersion(f, fnSafetyCheck) {
        return function (v) {
            return maybe(fnSafetyCheck(v) ? f(v) : undefined);
        }
    }

    var safe_reciprocal = safeVersion(reciprocal, function (n) {
        return n !== 0;
    });

    var safe_root = safeVersion(root, function (n) {
        return n >= 0;
    });


    var safe_log = safeVersion(log, function (n) {
        return n > 0;
    });


    // THE DERIVATION OF THE SAFE VERSIONS USED THE 'UNIT' OR 'RETURN'
    // FUNCTION OF THE MAYBE MONAD

    // Named maybe() here, the unit function of the Maybe monad wraps a raw value
    // in a datatype with two elements: .isValid (Bool) and .value (Number)

    // a -> Ma
    function maybe(n) {
        return {
            isValid: (typeof n !== 'undefined'),
            value: n
        };
    }

    // THE PROBLEM FOR FUNCTION NESTING (COMPOSITION) OF THE SAFE FUNCTIONS
    // IS THAT THEIR INPUT AND OUTPUT TYPES ARE DIFFERENT

    // Our safe versions of the functions take simple numeric arguments, but return
    // wrapped results. If we feed a wrapped result as an input to another safe function,
    // it will choke on the unexpected type. The solution is to write a higher order
    // function (sometimes called 'bind' or 'chain') which handles composition, taking a
    // a safe function and a wrapped value as arguments,

    // The 'bind' function of the Maybe monad:
    // 1. Applies a 'safe' function directly to the raw unwrapped value, and
    // 2. returns the wrapped result.

    // Ma -> (a -> Mb) -> Mb
    function bind(maybeN, mf) {
        return (maybeN.isValid ? mf(maybeN.value) : maybeN);
    }

    // Using the bind function, we can nest applications of safe_ functions,
    // without their choking on unexpectedly wrapped values returned from
    // other functions of the same kind.
    var rootOneOverFour = bind(
        bind(maybe(4), safe_reciprocal), safe_root
    ).value;

    // -> 0.5


    // We can compose a chain of safe functions (of any length) with a simple foldr/reduceRight
    // which starts by 'lifting' the numeric argument into a Maybe wrapping,
    // and then nests function applications (working from right to left)
    function safeCompose(lstFunctions, value) {
        return lstFunctions
            .reduceRight(function (a, f) {
                return bind(a, f);
            }, maybe(value));
    }

    // TEST INPUT VALUES WITH A SAFELY COMPOSED VERSION OF LOG(SQRT(1/X))

    var safe_log_root_reciprocal = function (n) {
        return safeCompose([safe_log, safe_root, safe_reciprocal], n).value;
    }

    return [-2, -1, -0.5, 0, 1 / Math.E, 1, 2, Math.E, 3, 4, 5].map(
        safe_log_root_reciprocal
    );

})();
