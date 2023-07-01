(() => {
    'use strict';

    // ARITHMETIC-GEOMETRIC MEAN

    // agm :: Num a => a -> a -> a
    let agm = (a, g) => {
            let abs = Math.abs,
                sqrt = Math.sqrt;

            return until(
                    m => abs(m.an - m.gn) < tolerance,
                    m => {
                        return {
                            an: (m.an + m.gn) / 2,
                            gn: sqrt(m.an * m.gn)
                        };
                    }, {
                        an: (a + g) / 2,
                        gn: sqrt(a * g)
                    }
                )
                .an;
        },

        // GENERIC

        // until :: (a -> Bool) -> (a -> a) -> a -> a
        until = (p, f, x) => {
            let v = x;
            while (!p(v)) v = f(v);
            return v;
        };


    // TEST

    let tolerance = 0.000001;


    return agm(1, 1 / Math.sqrt(2));

})();
