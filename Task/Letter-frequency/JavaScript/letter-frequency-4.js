(() => {
    'use strict';

    const letterfreq = text => [...text]
        .reduce(
            (a, c) => (a[c] = (a[c] || 0) + 1, a),
            {}
        );

    return JSON.stringify(
        letterfreq(
            `remember, remember, the fifth of november
             gunpowder treason and plot
             I see no reason why gunpowder treason
             should ever be forgot`
        ),
        null, 2
    );
})();
