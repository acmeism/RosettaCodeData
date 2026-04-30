// Arithmetic numbers

var n = 1;
var arithmCnt = 0;
var composCnt = 0;
var outStr = new String();
console.log("The first 100 arithmetic numbers are:");
while (arithmCnt < 1000001) {
  let dv = 1;
  let dvCnt = 0;
  let sum = 0;
  while (true) {
    quot = Math.floor(n / dv);
    if (quot < dv)
      break;
    if (quot == dv && n % dv == 0) {
      // n is a square
      sum += quot;
      dvCnt++;
      break;
    }
    if (n % dv == 0) {
      sum += dv + quot;
      dvCnt += 2;
    }
    dv++;
  }
  if (sum % dvCnt == 0) {
    // n is arithmetic
    arithmCnt++;
    if (arithmCnt <= 100) {
      outStr += n.toString().padStart(4, ' ');
      if (arithmCnt % 10 == 0) {
        console.log(outStr);
        outStr = "";
      }
    }
    if (dvCnt > 2)
      composCnt++;
    if (arithmCnt == 1000 || arithmCnt == 10000 || arithmCnt == 100000 || arithmCnt == 1000000) {
      console.log(outStr);
      outStr = "The " + arithmCnt.toString().padStart(7, ' ') +
          "th arithmetic number is " + n.toString().padStart(8, ' ') +
          " up to which " + composCnt.toString().padStart(6, ' ') +
          " are composite.";
    }
  }
  n++;
}
console.log(outStr);
