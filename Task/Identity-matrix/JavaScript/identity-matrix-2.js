(() => {

    // idMatrix :: Int -> [[0 | 1]]
    const idMatrix = n => Array.from({
            length: n
        }, (_, i) => Array.from({
            length: n
        }, (_, j) => i !== j ? 0 : 1));

    // show :: a -> String
    const show = JSON.stringify;

    // TEST
    return idMatrix(5)
        .map(show)
        .join('\n');
})();
