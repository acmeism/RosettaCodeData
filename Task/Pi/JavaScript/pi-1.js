let q = 1n, r = 180n, t = 60n, i = 2n;
for (;;) {
  let y = (q*(27n*i-12n)+5n*r)/(5n*t);
  let u = 3n*(3n*i+1n)*(3n*i+2n);
  r = 10n*u*(q*(5n*i-2n)+r-y*t);
  q = 10n*q*i*(2n*i-1n);
  t = t*u;
  i = i+1n;
  process.stdout.write(y.toString());
  if (i === 3n) { process.stdout.write('.'); }
}
