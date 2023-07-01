(() => {
    'use strict';

    // amb :: [a] -> (a -> [b]) -> [b]
    const amb = xs => f =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // when :: Bool -> [a] -> [a]
    const when = p =>
        xs => p ? (
            xs
        ) : [];


    // TEST -----------------------------------------------
    const main = () => {

        // joins :: String -> String -> Bool
        const joins = (a, b) =>
            b[0] === last(a);

        console.log(
            amb(['the', 'that', 'a'])
            (w1 => when(true)(

                amb(['frog', 'elephant', 'thing'])
                (w2 => when(joins(w1, w2))(

                    amb(['walked', 'treaded', 'grows'])
                    (w3 => when(joins(w2, w3))(

                        amb(['slowly', 'quickly'])
                        (w4 => when(joins(w3, w4))(

                            unwords([w1, w2, w3, w4])

                        ))
                    ))
                ))
            ))
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // MAIN ---
    return main();
})();
