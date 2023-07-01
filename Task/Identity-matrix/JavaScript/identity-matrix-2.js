(() => {

    // identityMatrix :: Int -> [[Int]]
    const identityMatrix = n =>
        Array.from({
            length: n
        }, (_, i) => Array.from({
            length: n
        }, (_, j) => i !== j ? 0 : 1));


    // ----------------------- TEST ------------------------
    return identityMatrix(5)
        .map(JSON.stringify)
        .join('\n');
})();
