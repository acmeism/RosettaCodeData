(() => {

    // (arbitrary arity to fully curried)
    // extraCurry :: Function -> Function
    let extraCurry = (f, ...args) => {
        let intArgs = f.length;

        // Recursive currying
        let _curry = (xs, ...arguments) =>
            xs.length >= intArgs ? (
                f.apply(null, xs)
            ) : function () {
                return _curry(xs.concat([].slice.apply(arguments)));
            };

        return _curry([].slice.call(args, 1));
    };

    // TEST

    // product3:: Num -> Num -> Num -> Num
    let product3 = (a, b, c) => a * b * c;

    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .map(extraCurry(product3)(7)(2))

    // [14, 28, 42, 56, 70, 84, 98, 112, 126, 140]

})();
