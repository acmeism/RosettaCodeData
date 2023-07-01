function uniq(lst) {
  var u = [],
    dct = {},
    i = lst.length,
    v;

  while (i--) {
    v = lst[i], dct[v] || (
      dct[v] = u.push(v)
    );
  }
  u.sort(); // optional

  return u;
}
