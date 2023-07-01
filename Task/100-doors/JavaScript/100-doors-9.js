(function (n) {


    // ONLY PERFECT SQUARES HAVE AN ODD NUMBER OF INTEGER FACTORS
    // (Leaving the door open at the end of the process)

    return perfectSquaresUpTo(n);


    // perfectSquaresUpTo :: Int -> [Int]
    function perfectSquaresUpTo(n) {
        return range(1, Math.floor(Math.sqrt(n)))
            .map(x => x * x);
    }


    // GENERIC

    // range(intFrom, intTo, optional intStep)
    // Int -> Int -> Maybe Int -> [Int]
    function range(m, n, step) {
        let d = (step || 1) * (n >= m ? 1 : -1);

        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    }

})(100);
