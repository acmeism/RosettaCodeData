(() => {
    // CARTESIAN PRODUCT OF TWO LISTS ---------------------

    // cartProd :: [a] -> [b] -> [[a, b]]
    const cartProd = xs => ys =>
        xs.flatMap(x => ys.map(y => [x, y]))


    // TEST -----------------------------------------------
    return [
        cartProd([1, 2])([3, 4]),
        cartProd([3, 4])([1, 2]),
        cartProd([1, 2])([]),
        cartProd([])([1, 2]),
    ].map(JSON.stringify).join('\n');
})();
