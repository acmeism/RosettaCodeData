// Department numbers
console.log(`POLICE SANITATION FIRE`);
let f: number;
for (var p = 2; p <= 7; p += 2) {
  for (var s = 1; s <= 7; s++) {
    if (s != p) {
      f = (12 - p) - s;
      if ((f > 0) && (f <= 7) && (f != s) && (f != p))
        console.log(`   ${p}       ${s}       ${f}`);
    }
  }
}
