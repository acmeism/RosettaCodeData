 (n => {

     let flatMap = (xs, f) => [].concat.apply([], xs.map(f)),

         range = (m, n) => Array.from({
             length: (n - m) + 1
         }, (_, i) => m + i);


     return flatMap(range(1,     n), (x) =>
            flatMap(range(1 + x, n), (y) =>
            flatMap(range(1 + y, n), (z) =>
                 x * x + y * y === z * z ? [
                     [x, y, z]
                 ] : []
             )));

 })(20);
