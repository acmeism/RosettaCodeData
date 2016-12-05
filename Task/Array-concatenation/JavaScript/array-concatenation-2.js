(function () {
    'use strict';

    // concat :: [[a]] -> [a]
    function concat(xs) {
        return [].concat.apply([], xs);
    }


   return concat(
      [["alpha", "beta", "gamma"],
      ["delta", "epsilon", "zeta"],
      ["eta", "theta", "iota"]]
  );

})();
