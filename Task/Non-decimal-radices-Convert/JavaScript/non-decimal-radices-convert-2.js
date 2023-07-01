var baselist = "0123456789abcdefghijklmnopqrstuvwxyz", listbase = [];
for(var i = 0; i < baselist.length; i++) listbase[baselist[i]] = i; // Generate baselist reverse
function basechange(snumber, frombase, tobase)
{
 var i, t, to = new Array(Math.ceil(snumber.length * Math.log(frombase) / Math.log(tobase))), accumulator;
 if(1 < frombase < baselist.length || 1 < tobase < baselist.length) console.error("Invalid or unsupported base!");
 while(snumber[0] == baselist[0] && snumber.length > 1) snumber = snumber.substr(1); // Remove leading zeros character
 console.log("Number is", snumber, "in base", frombase, "to base", tobase, "result should be",
             parseInt(snumber, frombase).toString(tobase));
 for(i = snumber.length - 1, inexp = 1; i > -1; i--, inexp *= frombase)
  for(accumulator = listbase[snumber[i]] * inexp, t = to.length - 1; accumulator > 0 || t >= 0; t--)
  {
   accumulator += listbase[to[t] || 0];
   to[t] = baselist[(accumulator % tobase)  || 0];
   accumulator = Math.floor(accumulator / tobase);
  }
 return to.join('');
}
console.log("Result:", basechange("zzzzzzzzzz", 36, 10));
