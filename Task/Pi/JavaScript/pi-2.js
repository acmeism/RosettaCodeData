<html><head><script src='https://rawgit.com/andyperlitch/jsbn/v1.1.0/index.js'></script></head>
<body style="width: 100%"><tt id="pi"></tt><tt>...</tt>
<script async defer>
function bi(n, b) { return new jsbn.BigInteger(n.toString(), b ? b : 10); };
var one=bi(1), two=bi(2), three=bi(3), four=bi(4), seven=bi(7), ten=bi(10);
function calcPi() {
    var q=bi(1), r=bi(0), t=bi(1), k=bi(1), n=bi(3), l=bi(3);
    var digit=0, firstrun=1;
    var p=document.getElementById('pi');
    function w(s) { p.appendChild(document.createTextNode(s));}
    function continueCalcPi(q, r, t, k, n, l) {
        while (true) {
            if (q.multiply(four).add(r).subtract(t).compareTo(n.multiply(t)) < 0) {
                w(n.toString());
                if (digit==0 && firstrun==1) { w('.'); firstrun=0; };
                digit = (digit+1) % 256;
                var nr = (r.subtract(n.multiply(t))).multiply(ten);
                n  = (q.multiply(three).add(r)).multiply(ten).divide(t).subtract(n.multiply(ten));
                q  = q.multiply(ten);
                r  = nr;
                if (digit%8==0) {
                    if (digit%64==0) {
                     p.appendChild(document.createElement('br'));
                    }
                    w(' ');
                    return setTimeout(function() { continueCalcPi(q, r, t, k, n, l); }, 50);
                };
            } else {
                var nr = q.shiftLeft(1).add(r).multiply(l);
                var nn = q.multiply(k).multiply(seven).add(two).add(r.multiply(l)).divide(t.multiply(l));
                q = q.multiply(k);
                t = t.multiply(l);
                l = l.add(two);
                k = k.add(one);
                n  = nn;
                r  = nr;
            }
        }
    }
    continueCalcPi(q, r, t, k, n, l);
}
calcPi();
</script>
</body></html>
