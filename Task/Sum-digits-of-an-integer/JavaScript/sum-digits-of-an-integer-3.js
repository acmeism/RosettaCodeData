(() => {
    "use strict";

    // -------------- INTEGER DIGITS SUMMED --------------

    // digitsSummed :: (Int | String) -> Int
    const digitsSummed = number => {

        // 10 digits + 26 alphabetics
        // give us glyphs for up to base 36
        const intMaxBase = 36;

        return `${number}`
            .split("")
            .reduce(
                (sofar, digit) => sofar + parseInt(
                    digit, intMaxBase
                ),
                0
            );
    };

    // ---------------------- TEST -----------------------
    return [1, 12345, 0xfe, "fe", "f0e", "999ABCXYZ"]
        .map((x) => `${x} -> ${digitsSummed(x)}`)
        .join("\n");
})();
