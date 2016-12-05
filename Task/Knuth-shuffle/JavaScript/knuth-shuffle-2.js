(lst => {

    // knuthShuffle :: [a] -> [a]
    let knuthShuffle = lst =>
        range(0, lst.length - 1)
        .reduceRight((a, i) => {
            let iRand = i ? randomInteger(0, i) : 0,
                tmp = a[iRand];

            return iRand !== i ?  (
                a[iRand] = a[i],
                a[i] = tmp,
                a
            ) : a;
        }, lst),

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
