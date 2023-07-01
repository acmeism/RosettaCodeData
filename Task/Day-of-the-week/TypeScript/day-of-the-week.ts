// Find years with Sunday Christmas
var f = 2008;
var t = 2121;
console.log(`Sunday Christmases ${f} - ${t}`);
for (y = f; y <= t; y++) {
  var x = (y * 365) + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) - 6;
  if (x % 7 == 0)
    process.stdout.write(`${y}\t`);
}
process.stdout.write("\n");
