(() => {
    "use strict";

    // ------ ANGLE DIFFERENCE BETWEEN TWO BEARINGS ------

    // bearingDelta :: Radians -> Radians -> Radians
    const bearingDelta = a =>
        // The difference between two bearings: a and b.
        b => {
            const [ax, ay] = [sin(a), cos(a)];
            const [bx, by] = [sin(b), cos(b)];

            // Cross-product above zero ?
            const sign = ((ay * bx) - (by * ax)) > 0 ? (
                +1
            ) : -1;

            // Sign * dot-product.
            return sign * acos((ax * bx) + (ay * by));
        };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => [
            [20, 45],
            [-45, 45],
            [-85, 90],
            [-95, 90],
            [-45, 125],
            [-45, 145]
        ].map(xy => showMap(...xy))
        .join("\n");


    // ------------------- FORMATTING --------------------

    // showMap :: Degrees -> Degrees -> String
    const showMap = (da, db) => {
        const
            delta = degreesFromRadians(
                bearingDelta(
                    radiansFromDegrees(da)
                )(
                    radiansFromDegrees(db)
                )
            )
            .toPrecision(4),
            theta = `${da}° +`.padStart(6, " "),
            theta1 = ` ${db}°  ->  `.padStart(11, " "),
            diff = `${delta}°`.padStart(7, " ");

        return `${theta}${theta1}${diff}`;
    };

    // --------------------- GENERIC ---------------------

    // radiansFromDegrees :: Float -> Float
    const radiansFromDegrees = n =>
        Pi * n / 180.0;

    // degreesFromRadians :: Float -> Float
    const degreesFromRadians = x =>
        180.0 * x / Pi;

    // Abbreviations for trigonometric methods and
    // properties of the standard Math library.
    const [
        Pi, sin, cos, acos
    ] = ["PI", "sin", "cos", "acos"]
    .map(k => Math[k]);

    // MAIN ---
    return main();
})();
