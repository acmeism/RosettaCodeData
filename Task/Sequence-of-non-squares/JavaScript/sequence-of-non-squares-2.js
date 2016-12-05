(() => {

    // nonSquare :: Int -> Int
    let nonSquare = n =>
        n + floor(1 / 2 + sqrt(n));



    // floor :: Num -> Int
    let floor = Math.floor,

        // sqrt :: Num -> Num
        sqrt = Math.sqrt,

        // isSquare :: Int -> Bool
        isSquare = n => {
            let root = sqrt(n);

            return root === floor(root);
        };


    // TEST
    return {
        first22: Array.from({
            length: 22
        }, (_, i) => nonSquare(i + 1)),

        firstMillionNotSquare: Array.from({
                length: 10E6
            }, (_, i) => nonSquare(i + 1))
            .filter(isSquare)
            .length === 0
    };

})();
