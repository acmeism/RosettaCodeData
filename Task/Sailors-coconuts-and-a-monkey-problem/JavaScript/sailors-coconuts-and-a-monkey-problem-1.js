(function () {

    // wakeSplit :: Int -> Int -> Int -> Int
    function wakeSplit(intNuts, intSailors, intDepth) {
        var nDepth = intDepth !== undefined ? intDepth : intSailors,
            portion = Math.floor(intNuts / intSailors),
            remain = intNuts % intSailors;

        return 0 >= portion || remain !== (nDepth ? 1 : 0) ?
            null : nDepth ? wakeSplit(
                intNuts - portion - remain, intSailors, nDepth - 1
            ) : intNuts;
    }

    // TEST for 5, 6, and 7 intSailors
    return [5, 6, 7].map(function (intSailors) {
        var intNuts = intSailors;

        while (!wakeSplit(intNuts, intSailors)) intNuts += 1;

        return intNuts;
    });
})();
