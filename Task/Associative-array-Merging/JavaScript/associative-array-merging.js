(() => {
    'use strict';

    console.log(JSON.stringify(
        Object.assign({}, // Fresh dictionary.
            { // Base.
                "name": "Rocket Skates",
                "price": 12.75,
                "color": "yellow"
            }, { // Update.
                "price": 15.25,
                "color": "red",
                "year": 1974
            }
        ),
        null, 2
    ))
})();
