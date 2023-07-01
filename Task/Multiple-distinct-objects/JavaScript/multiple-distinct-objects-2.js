(n => {

    let nObjects = n => Array.from({
            length: n + 1
        }, (_, i) => {
            // optionally indexed object constructor
            return {
                index: i
            };
        });

    return nObjects(6);

})(6);
