function* nPowerGen(n) {
  let e = 0;
  while (1) { e++ && (yield Math.pow(e, n)); }
}

function* filterGen(gS, gC, skip=0) {
  let s = 0; // The square value
  let c = 0; // The cube value
  let n = 0; // A skip counter

  while(1) {
    s = gS.next().value;
    s > c && (c = gC.next().value);
    s == c ?
      c = gC.next().value :
      n++ && n > skip && (yield s);
  }
}

const filtered = filterGen(nPowerGen(2), nPowerGen(3), skip=20);
