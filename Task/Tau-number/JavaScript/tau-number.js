// Tau number

// Return the Tau (number of divisors) of n
function tau(n) {
  var t, limit;
  if (n < 3) {
    t = n;
  } else {
    t = 2;
    limit = Math.floor((n + 1) / 2);
    for (var i = 2; i <= limit; i++)
      if (n % i == 0)
        t++;
  }
  return t;
}

console.log("First 100 Tau numbers:");
var c = 0, p = c % 10;
var i = 1;
var out = new Array(10);
while (c < 100) {
  if (i % tau(i) == 0) {
    out[p] = i.toString().padStart(5, ' ');
    c++;
    p = c % 10;
    if (p == 0)
      console.log(out.join(""));
  }
  i++;
}
console.log();
