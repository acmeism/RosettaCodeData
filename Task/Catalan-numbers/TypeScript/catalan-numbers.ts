// Catalan numbers
var c: number[] = [1];
console.log(`${0}\t${c[0]}`);
for (n = 0; n < 15; n++) {
  c[n + 1] = 0;
  for (i = 0; i <= n; i++)
    c[n + 1] = c[n + 1] + c[i] * c[n - i];
  console.log(`${n + 1}\t${c[n + 1]}`);
}
