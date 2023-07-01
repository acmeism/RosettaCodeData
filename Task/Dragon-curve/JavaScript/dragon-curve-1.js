var DRAGON = (function () {
   // MATRIX MATH
   // -----------

   var matrix = {
      mult: function ( m, v ) {
         return [ m[0][0] * v[0] + m[0][1] * v[1],
                  m[1][0] * v[0] + m[1][1] * v[1] ];
      },

      minus: function ( a, b ) {
         return [ a[0]-b[0], a[1]-b[1] ];
      },

      plus: function ( a, b ) {
         return [ a[0]+b[0], a[1]+b[1] ];
      }
   };


   // SVG STUFF
   // ---------

   // Turn a pair of points into an SVG path like "M1 1L2 2".
   var toSVGpath = function (a, b) {  // type system fail
      return "M" + a[0] + " " + a[1] + "L" + b[0] + " " + b[1];
   };


   // DRAGON MAKING
   // -------------

   // Make a dragon with a better fractal algorithm
   var fractalMakeDragon = function (svgid, ptA, ptC, state, lr, interval) {

      // make a new <path>
      var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      path.setAttribute( "class",  "dragon");
      path.setAttribute( "d", toSVGpath(ptA, ptC) );

      // append the new path to the existing <svg>
      var svg = document.getElementById(svgid); // call could be eliminated
      svg.appendChild(path);

      // if we have more iterations to go...
      if (state > 1) {

         // make a new point, either to the left or right
         var growNewPoint = function (ptA, ptC, lr) {
            var left  = [[ 1/2,-1/2 ],
                         [ 1/2, 1/2 ]];

            var right = [[ 1/2, 1/2 ],
                         [-1/2, 1/2 ]];

            return matrix.plus(ptA, matrix.mult( lr ? left : right,
                                                 matrix.minus(ptC, ptA) ));
         };

         var ptB = growNewPoint(ptA, ptC, lr, state);

         // then recurse using each new line, one left, one right
         var recurse = function () {
            // when recursing deeper, delete this svg path
            svg.removeChild(path);

            // then invoke again for new pair, decrementing the state
            fractalMakeDragon(svgid, ptB, ptA, state-1, lr, interval);
            fractalMakeDragon(svgid, ptB, ptC, state-1, lr, interval);
         };

         window.setTimeout(recurse, interval);
      }
   };


   // Export these functions
   // ----------------------
   return {
      fractal: fractalMakeDragon

      // ARGUMENTS
      // ---------
      //    svgid    id of <svg> element
      //    ptA      first point [x,y] (from top left)
      //    ptC      second point [x,y]
      //    state    number indicating how many steps to recurse
      //    lr       true/false to make new point on left or right

      // CONFIG
      // ------
      // CSS rules should be made for the following
      //    svg#fractal
      //    svg path.dragon
   };

}());
