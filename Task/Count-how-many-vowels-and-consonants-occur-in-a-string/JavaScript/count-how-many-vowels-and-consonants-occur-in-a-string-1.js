(() => {
    "use strict";

    // -------- COUNT OF "VOWELS AND CONSONANTS" ---------

    // countOfVowelsAndConsonants :: String -> Int
    const countOfVowelsAndConsonants = s =>
        Array.from(s).filter(isAlpha).length;


    // ---------------------- TEST -----------------------
    const main = () =>
        `${countOfVowelsAndConsonants(
            "Forever Fortran 2018 programming language"
        )} "vowels and consonants"`;


    // --------------------- GENERIC ---------------------

    // isAlpha :: Char -> Bool
    const isAlpha = c =>
        (/[A-Za-z\u00C0-\u00FF]/u).test(c);


    // MAIN ---
    return main();
})();
