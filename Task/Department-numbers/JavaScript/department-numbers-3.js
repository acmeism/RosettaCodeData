(() => {
    "use strict";

    const
        label = "(Police, Sanitation, Fire)",
        solutions = [2, 4, 6]
        .flatMap(
            x => [1, 2, 3, 4, 5, 6, 7]
            .flatMap(
                y => [12 - (x + y)]
                .flatMap(
                    z => z !== y && 1 <= z && z <= 7 ? [
                        [x, y, z]
                    ] : []
                )
            )
        )
        .map(JSON.stringify)
        .join("\n");

    return `${label}\n${solutions}`;
})();
