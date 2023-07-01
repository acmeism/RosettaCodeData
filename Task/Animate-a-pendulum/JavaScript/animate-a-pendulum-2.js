<svg height="100%" width="100%" viewBox="-2 0 4 4" xmlns="http://www.w3.org/2000/svg">
  <line id="string" x1="0" y1="0" x2="1" y2="0" stroke="grey" stroke-width="0.05" />
  <circle id="ball" cx="0" cy="0" r="0.1" fill="black" />
  <script>
    /*jshint esnext: true */

    function rk4(dt, x, f) {
      "use strict";
      let from = Array.from,
          a = from(f(from(x,  $    => $         )), $ => $*dt),
          b = from(f(from(x, ($,i) => $ + a[i]/2)), $ => $*dt),
          c = from(f(from(x, ($,i) => $ + b[i]/2)), $ => $*dt),
          d = from(f(from(x, ($,i) => $ + c[i]  )), $ => $*dt);
      return from(x, (_,i) => (a[i] + 2*b[i] + 2*c[i] + d[i])/6);
    }

    function setPendulumPos($) {
      const string = document.getElementById("string"),
            ball = document.getElementById("ball");
      let $2 = $*$,
          x = 2*$/(1+$2),
          y = (1-$2)/(1+$2);
      string.setAttribute("x2", x);
      string.setAttribute("y2", y);
      ball.setAttribute("cx", x);
      ball.setAttribute("cy", y);
    }

    var q = [1, 0];
    var previousTimestamp;
    (function animate(timestamp) {
      if ( previousTimestamp !== undefined) {
        let dq = rk4((timestamp - previousTimestamp)/1000, q, $ => [$[1], 2*$[1]*$[1]*$[0]/(1+$[0]*$[0]) - $[0]]);
        q = [q[0] + dq[0], q[1] + dq[1]];
        setPendulumPos(q[0]);
      }
      previousTimestamp = timestamp;
      window.requestAnimationFrame(animate);
    })()
  </script>
</svg>
