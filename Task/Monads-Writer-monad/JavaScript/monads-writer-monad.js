(function () {
    'use strict';

    // START WITH THREE SIMPLE FUNCTIONS

    // Square root of a number more than 0
    function root(x) {
        return Math.sqrt(x);
    }

    // Add 1
    function addOne(x) {
        return x + 1;
    }

    // Divide by 2
    function half(x) {
        return x / 2;
    }


    // DERIVE LOGGING VERSIONS OF EACH FUNCTION

    function loggingVersion(f, strLog) {
        return function (v) {
            return {
                value: f(v),
                log: strLog
            };
        }
    }

    var log_root = loggingVersion(root, "obtained square root"),

        log_addOne = loggingVersion(addOne, "added 1"),

        log_half = loggingVersion(half, "divided by 2");


    // UNIT/RETURN and BIND for the the WRITER MONAD

    // The Unit / Return function for the Writer monad:
    // 'Lifts' a raw value into the wrapped form
    // a -> Writer a
    function writerUnit(a) {
        return {
            value: a,
            log: "Initial value: " + JSON.stringify(a)
        };
    }

    // The Bind function for the Writer monad:
    // applies a logging version of a function
    // to the contents of a wrapped value
    // and return a wrapped result (with extended log)

    // Writer a -> (a -> Writer b) -> Writer b
    function writerBind(w, f) {
        var writerB = f(w.value),
            v = writerB.value;

        return {
            value: v,
            log: w.log + '\n' + writerB.log + ' -> ' + JSON.stringify(v)
        };
    }

    // USING UNIT AND BIND TO COMPOSE LOGGING FUNCTIONS

    // We can compose a chain of Writer functions (of any length) with a simple foldr/reduceRight
    // which starts by 'lifting' the initial value into a Writer wrapping,
    // and then nests function applications (working from right to left)
    function logCompose(lstFunctions, value) {
        return lstFunctions.reduceRight(
            writerBind,
            writerUnit(value)
        );
    }

    var half_of_addOne_of_root = function (v) {
        return logCompose(
            [log_half, log_addOne, log_root], v
        );
    };

    return half_of_addOne_of_root(5);
})();
