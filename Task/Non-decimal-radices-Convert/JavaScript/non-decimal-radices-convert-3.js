// Tom Wu jsbn.js http://www-cs-students.stanford.edu/~tjw/jsbn/
var baselist = "0123456789abcdefghijklmnopqrstuvwxyz", listbase = [];
for(var i = 0; i < baselist.length; i++) listbase[baselist[i]] = i; // Generate baselist reverse
function baseconvert(snumber, frombase, tobase) // String number in base X to string number in base Y, arbitrary length, base
{
 var i, t, to, accum = new BigInteger(), inexp = new BigInteger('1', 10), tb = new BigInteger(),
     fb = new BigInteger(), tmp = new BigInteger();
 console.log("Number is", snumber, "in base", frombase, "to base", tobase, "result should be",
             frombase < 37 && tobase < 37 ? parseInt(snumber, frombase).toString(tobase) : 'too large');
 while(snumber[0] == baselist[0] && snumber.length > 1) snumber = snumber.substr(1); // Remove leading zeros
 tb.fromInt(tobase);
 fb.fromInt(frombase);
 for(i = snumber.length - 1, to = new Array(Math.ceil(snumber.length * Math.log(frombase) / Math.log(tobase))); i > -1; i--)
 {
  accum = inexp.clone();
  accum.dMultiply(listbase[snumber[i]]);
  for(t = to.length - 1; accum.compareTo(BigInteger.ZERO) > 0 || t >= 0; t--)
  {
   tmp.fromInt(listbase[to[t]] || 0);
   accum = accum.add(tmp);
   to[t] = baselist[accum.mod(tb).intValue()];
   accum = accum.divide(tb);
  }
  inexp = inexp.multiply(fb);
 }
 while(to[0] == baselist[0] && to.length > 1) to = to.slice(1); // Remove leading zeros
 return to.join('');
}
