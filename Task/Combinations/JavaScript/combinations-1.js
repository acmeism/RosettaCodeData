function bitprint(u) {
  var s="";
  for (var n=0; u; ++n, u>>=1)
    if (u&1) s+=n+" ";
  return s;
}
function bitcount(u) {
  for (var n=0; u; ++n, u=u&(u-1));
  return n;
}
function comb(c,n) {
  var s=[];
  for (var u=0; u<1<<n; u++)
    if (bitcount(u)==c)
      s.push(bitprint(u))
  return s.sort();
}
comb(3,5)
