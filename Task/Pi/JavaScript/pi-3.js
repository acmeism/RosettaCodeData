<html>
 <head>
 </head>
 <body style="width: 100%">
  <tt id="pi"></tt>
  <tt>...</tt>
  <script async defer>
function calcPi() {
    let q=1n, r=0n, t=1n, k=1n, n=3n, l=3n, nr, nn, digit=0, firstrun=1;
    const p=document.getElementById('pi');
    function w(s) { p.appendChild(document.createTextNode(s));}
//  function continueCalcPi(q, r, t, k, n, l) {  // (see note)
    function continueCalcPi() {
        while (true) {
            if (q*4n+r-t < n*t) {
                w(n.toString());
                if (digit==0 && firstrun==1) { w('.'); firstrun=0; };
                digit = (digit+1) % 256;
                nr = (r-n*t)*10n;
                n  = (q*3n+r)*10n/t-n*10n;
                q *= 10n;
                r  = nr;
                if (digit%8==0) {
                    if (digit%64==0) {
                     p.appendChild(document.createElement('br'));
                    }
                    w('\xA0');
//                  return setTimeout(function() { continueCalcPi(q, r, t, k, n, l); }, 50);
                    return setTimeout(continueCalcPi, 50);
                };
            } else {
                nr = (q*2n+r)*l;
                nn = (q*k*7n+2n+r*l)/(t*l);
                q *= k;
                t *= l;
                l += 2n;
                k += 1n;
                n  = nn;
                r  = nr;
            }
        }
    }
    continueCalcPi(q, r, t, k, n, l);
}
calcPi();
  </script>
 </body>
</html>
