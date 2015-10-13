function lcs_greedy(x,y){
  var p1, i, idx,
      symbols = {},
      r = 0,
      p = 0,
      l = 0,
      m = x.length,
      n = y.length,
      s = new Buffer((m < n) ? n : m);

  p1 = popsym(0);

  for (i = 0; i < m; i++) {
    p = (r === p) ? p1 : popsym(i);
    p1 = popsym(i + 1);
    if (p > p1) {
      i += 1;
      idx = p1;
    } else {
      idx = p;
    }

    if (idx === n) {
      p = popsym(i);
    } else {
      r = idx;
      s[l] = x.charCodeAt(i);
      l += 1;
    }
  }
  return s.toString('utf8', 0, l);
	
  function popsym(index) {
    var s = x[index],
        pos = symbols[s] + 1;

    pos = y.indexOf(s, ((pos > r) ? pos : r));
    if (pos === -1) { pos = n; }
    symbols[s] = pos;
    return pos;
  }
}
