(() => {
    "use strict";

    // ----------------- PANGRAM CHECKER -----------------

    // isPangram :: String -> Bool
    const isPangram = s =>
        0 === "abcdefghijklmnopqrstuvwxyz"
        .split("")
        .filter(c => -1 === s.toLowerCase().indexOf(c))
        .length;

    // ---------------------- TEST -----------------------
    return [
        "is this a pangram",
        "The quick brown fox jumps over the lazy dog"
    ].map(isPangram);
})();
