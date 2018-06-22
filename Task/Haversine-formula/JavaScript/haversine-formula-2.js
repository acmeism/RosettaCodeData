((x, y) => {
    'use strict';

    // haversine :: (Num, Num) -> (Num, Num) -> Num
    const haversine = ([lat1, lon1], [lat2, lon2]) => {
        // Math lib function names
        const [pi, asin, sin, cos, sqrt, pow, round] = [
            'PI', 'asin', 'sin', 'cos', 'sqrt', 'pow', 'round'
        ]
        .map(k => Math[k]),

            // degrees as radians
            [rlat1, rlat2, rlon1, rlon2] = [lat1, lat2, lon1, lon2]
            .map(x => x / 180 * pi),

            dLat = rlat2 - rlat1,
            dLon = rlon2 - rlon1,
            radius = 6372.8; // km

        // km
        return round(
            radius * 2 * asin(
                sqrt(
                    pow(sin(dLat / 2), 2) +
                    pow(sin(dLon / 2), 2) *
                    cos(rlat1) * cos(rlat2)
                )
            ) * 100
        ) / 100;
    };

    // TEST
    return haversine(x, y);

    // --> 2887.26

})([36.12, -86.67], [33.94, -118.40]);
