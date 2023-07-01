(() => {

    // curry :: ((a, b) -> c) -> a -> b -> c
    let curry = f => a => b => f(a, b);


    // TEST

    // product :: Num -> Num -> Num
    let product = (a, b) => a * b,

        // Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        }


    return range(1, 10)
        .map(curry(product)(7))

    // [7, 14, 21, 28, 35, 42, 49, 56, 63, 70]

})();
