(() => {
    'use strict';

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // printAll [any] -> String
    const printAll = (...a) => a.map(show)
        .join('\n');

    return printAll(1, 2, 3, 2 + 2, "five", 6);
})();
