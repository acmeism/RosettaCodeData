(lst => {

    // knuthShuffle :: [a] -> [a]
    function knuthShuffle(lst) {
        let lng = lst.length;

        return lng ? range(0, lng - 1)
            .reduceRight((a, i) => {
                let iRand = i > 0 ? randomInteger(0, i) : 0;

                return i !== iRand ? swapped(a, i, iRand) : a;
            }, lst) : [];
    };


    // A non-mutating variant of swapped():

    // swapped :: [a] -> Int -> Int -> [a]
    let swapped = (lst, iFrom, iTo) => {
            let [iLow, iHigh] = iTo > iFrom ? (
                    [iFrom, iTo]
            ) : [iTo, iFrom];

            return iLow !== iHigh ? (
                    [].concat(
                        (iLow > 0 ? lst.slice(0, iLow) : []), // pre
                        lst[iHigh],                           // DOWN
                        lst.slice(iLow + 1, iHigh),           // mid
                        lst[iLow],                            // UP
                        lst.slice(iHigh + 1)                  // post
                    )
                ) : lst.slice(0) // (unchanged copy)
        },

        // randomInteger :: Int -> Int -> Int
        randomInteger = (low, high) =>
        low + Math.floor(
            (Math.random() * ((high - low) + 1))
        ),

        // range :: Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        };


    return knuthShuffle(lst);

})(
    'alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu'
    .split(' ')
);
