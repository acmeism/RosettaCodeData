(n => {

    // spiral :: the first row plus a smaller spiral rotated 90 degrees clockwise
    // spiral :: Int -> Int -> Int -> [[Int]]
    function spiral(lngRows, lngCols, nStart) {
        return lngRows ? [range(nStart, (nStart + lngCols) - 1)]
            .concat(
                transpose(
                    spiral(lngCols, lngRows - 1, nStart + lngCols)
                )
                .map(reverse)
            ) : [[]];
    }

    // transpose :: [[a]] -> [[a]]
    function transpose(xs) {
        return xs[0]
            .map((_, iCol) => xs
                .map((row) => row[iCol]));
    }

    // reverse :: [a] -> [a]
    function reverse(xs) {
        return xs.slice(0)
            .reverse();
    }

    // range(intFrom, intTo, optional intStep)
    // Int -> Int -> Maybe Int -> [Int]
    function range(m, n, step) {
        let d = (step || 1) * (n >= m ? 1 : -1);

        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    }



    // TESTING

    // replicate :: Int -> String -> String
    function replicate(n, a) {
        var v = [a],
            o = '';

        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o + v;
            n >>= 1;
            v = v + v;
        }
        return o + v;
    }


    return spiral(n, n, 0)
        .map(
            xs => xs.map(x => {
                let s = `${x}`;
                return replicate(4 - s.length, ' ') + s;
            })
            .join('')
        )
        .join('\n');

})(5);
