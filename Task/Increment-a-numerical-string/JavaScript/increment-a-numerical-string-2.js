(() => {
    'use strict';

    // stringSucc :: Maybe String -> Maybe String
    const stringSucc = s =>
        isNaN(s) ? undefined : (Number(s) + 1).toString();

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    return show(
        ['2', '4', '8', '16', 'anomaly'].map(stringSucc)
    );
})();
