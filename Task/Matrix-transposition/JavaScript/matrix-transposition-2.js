(function () {
    'use strict';

    function transpose(lst) {
        return lst[0].map(function (_, iCol) {
            return lst.map(function (row) {
                return row[iCol];
            })
        });
    }

    return transpose(
        [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    );

})();
