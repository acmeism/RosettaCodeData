(function () {

    // curry :: ((a, b) -> c) -> a -> b -> c
    function curry(f) {
        return function (a) {
            return function (b) {
                return f(a, b);
            };
        };
    }


    // TESTS

    // product :: Num -> Num -> Num
    function product(a, b) {
        return a * b;
    }

    // return typeof curry(product);
    // --> function

    // return typeof curry(product)(7)
    // --> function

    //return typeof curry(product)(7)(9)
    // --> number

    return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .map(curry(product)(7))

    // [7, 14, 21, 28, 35, 42, 49, 56, 63, 70]

})();
