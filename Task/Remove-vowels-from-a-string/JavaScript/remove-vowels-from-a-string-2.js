(() => {
    'use strict';

    // Parser :: String -> Parser String
    const purgedText = exclusions =>
        s => [...s]
        .filter(c => !exclusions.includes(c))
        .join('');

    // ---------------------- TEST -----------------------
    const main = () => {
        const txt = `
            Rosetta Code is a programming chrestomathy site.
            The idea is to present solutions to the same
            task in as many different languages as possible,
            to demonstrate how languages are similar and
            different, and to aid a person with a grounding
            in one approach to a problem in learning another.`;

        return purgedText('eau')(txt);
    };

    // main ---
    return main();
})();
