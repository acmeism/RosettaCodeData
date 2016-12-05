(function () {

    // (arbitrary arity to fully curried)
    // extraCurry :: Function -> Function
    function extraCurry(f) {

        // Recursive currying
        function _curry(xs) {
            return xs.length >= intArgs ? (
                f.apply(null, xs)
            ) : function () {
                return _curry(xs.concat([].slice.apply(arguments)));
            };
        }

        var intArgs = f.length;

        return _curry([].slice.call(arguments, 1));
    }


    // TEST

    // product3:: Num -> Num -> Num -> Num
    function product3(a, b, c) {
        return a * b * c;
    }

    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .map(extraCurry(product3)(7)(2))

    // [14, 28, 42, 56, 70, 84, 98, 112, 126, 140]

})();
