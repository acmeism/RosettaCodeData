(function () {
    'use strict';

    function a(bool) {
        console.log('a -->', bool);

        return bool;
    }

    function b(bool) {
        console.log('b -->', bool);

        return bool;
    }


    var x = a(false) && b(true),
        y = a(true) || b(false),
        z = true ? a(true) : b(false);

  return [x, y, z];
})();
