// Digital root

function rootAndPers(n: number, bas: number): [number, number] {
  var pers = 0;
  while (n >= bas)
  {
    var s = 0;
    do
    {
      s += n % bas;
      n = Math.floor(n / bas);
    } while (n > 0);
    pers++;
    n = s;
  }
  return [n, pers];
}

for (var a of [1, 14, 267, 8128, 39390, 588225, 627615]) {
  var rp = rootAndPers(a, 10);
  console.log(a.toString().padStart(7, ' ') +
    rp[1].toString().padStart(6, ' ') + rp[0].toString().padStart(6, ' '));
}
