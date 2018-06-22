var BigInteger = require('jsbn').BigInteger;
var bi = function(n, b) { return new BigInteger(n.toString(), b ? b : 10); };
function calcPi() {
    var q=bi(1), r=bi(0), t=bi(1), k=bi(1), n=bi(3), l=bi(3);
    var one=bi(1), two=bi(2), three=bi(3), four=bi(4), seven=bi(7), ten=bi(10);
    while (true) {
        if (q.multiply(four).add(r).subtract(t).compareTo(n.multiply(t)) < 0) {
            process.stdout.write(n.toString());
            nr = (r.subtract(n.multiply(t))).multiply(ten);
            n  = (q.multiply(three).add(r)).multiply(ten).divide(t).subtract(n.multiply(ten));
            q  = q.multiply(ten);
            r  = nr;
        } else {
            nr = q.shiftLeft(1).add(r).multiply(l);
            nn = q.multiply(k).multiply(seven).add(two).add(r.multiply(l)).divide(t.multiply(l));
            q = q.multiply(k);
            t = t.multiply(l);
            l = l.add(two);
            k = k.add(one);
            n  = nn;
            r  = nr;
        }
    }
}
calcPi();
