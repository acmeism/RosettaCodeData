(() => {
    'use strict';

    // diversityValues :: [Num] -> {
    //      mean-error ::  Float,
    //     crowd-error :: Float,
    //       diversity :: Float
    // }
    const diversityValues = observed =>
        predictions => {
            const predictionMean = mean(predictions);
            return {
                'mean-error': meanErrorSquared(observed)(
                    predictions
                ),
                'crowd-error': Math.pow(
                    observed - predictionMean,
                    2
                ),
                'diversity': meanErrorSquared(predictionMean)(
                    predictions
                )
            };
        };

    // meanErrorSquared :: Num a => a -> [a] -> b
    const meanErrorSquared = observed =>
        predictions => mean(
            predictions.map(x => Math.pow(x - observed, 2))
        );

    // mean :: Num a => [a] -> b
    const mean = xs => {
        const lng = xs.length;
        return lng > 0 ? (
            xs.reduce((a, b) => a + b, 0) / lng
        ) : undefined;
    };


    // ----------------------- TEST ------------------------
    const main = () =>
        JSON.stringify([{
            observed: 49,
            predictions: [48, 47, 51]
        }, {
            observed: 49,
            predictions: [48, 47, 51, 42]
        }].map(x => dictionaryAtPrecision(3)(
            diversityValues(x.observed)(
                x.predictions
            )
        )), null, 2);


    // ---------------------- GENERIC ----------------------

    // dictionaryAtPrecision :: Int -> Dict -> Dict
    const dictionaryAtPrecision = n =>
        // A dictionary of Float values, with
        // all Floats adjusted to a given precision.
        dct => Object.keys(dct).reduce(
            (a, k) => Object.assign(
                a, {
                    [k]: dct[k].toPrecision(n)
                }
            ), {}
        );

    // MAIN ---
    return main()
})();
