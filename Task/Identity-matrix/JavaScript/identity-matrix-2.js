(() => {

    // idMatrix :: Int -> [[0 | 1]]
    const idMatrix = n => Array.from({
            length: n
        }, (_, i) => Array.from({
            length: n
        }, (_, j) => i !== j ? 0 : 1));


    // TEST
    return idMatrix(5);
})();
