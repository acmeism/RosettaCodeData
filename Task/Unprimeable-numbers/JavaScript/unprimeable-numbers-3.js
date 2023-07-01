let unprimeables = [],
    endings = new Array(10).fill('-'),
    c = 1;
function chkEnds(n) {
  let e = n % 10;
  if (endings[e] == '-') endings[e] = n;
}
console.time('I');
while (unprimeables.length < 1000) {
  if (isUnprimable(c)) {
    unprimeables.push(c);
    chkEnds(c)
  }
  c++;
}
console.log('The first 35 unprimeables:');
console.log(unprimeables.slice(0,35).join(', '));
console.log(`The 600th unprimeable: ${unprimeables[599].toLocaleString('en')}`);
console.log(`The 1000th unprimable: ${unprimeables[999].toLocaleString('en')}`);
console.timeEnd('I');
console.time('II');
while (endings.includes('-')) {
  c++;
  if (isUnprimable(c)) chkEnds(c);
}
for (c = 0; c < endings.length; c++) {
  console.log(`First unprimeable ending with ${c}: ${endings[c].toLocaleString('en')}`);
}
console.timeEnd('II');
