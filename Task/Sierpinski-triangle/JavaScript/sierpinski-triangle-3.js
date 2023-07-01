(() => {
    "use strict";

    // --------------- SIERPINSKI TRIANGLE ---------------

    // sierpinski :: Int -> String
    const sierpinski = n =>
        Array.from({
            length: n
        })
        .reduce(
            (xs, _, i) => {
                const s = " ".repeat(2 ** i);

                return [
                    ...xs.map(x => s + x + s),
                    ...xs.map(x => `${x} ${x}`)
                ];
            },
            ["*"]
        )
        .join("\n");

    // ---------------------- TEST -----------------------
    return sierpinski(4);
})();
