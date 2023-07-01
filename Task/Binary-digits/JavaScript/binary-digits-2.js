(() => {
    "use strict";

    // ------------------ BINARY DIGITS ------------------

    // showBinary :: Int -> String
    const showBinary = n =>
        showIntAtBase_(2)(n);


    // showIntAtBase_ :: // Int -> Int -> String
    const showIntAtBase_ = base =>
        n => n.toString(base);


    // ---------------------- TEST -----------------------
    const main = () => [5, 50, 9000]
        .map(n => `${n} -> ${showBinary(n)}`)
        .join("\n");


    // MAIN ---
    return main();
})();
