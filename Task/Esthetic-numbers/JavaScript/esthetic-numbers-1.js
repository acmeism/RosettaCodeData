function isEsthetic(inp, base = 10) {
  let arr = inp.toString(base).split('');
  if (arr.length == 1) return false;
  for (let i = 0; i < arr.length; i++)
    arr[i] = parseInt(arr[i], base);
  for (i = 0; i < arr.length-1; i++)
    if (Math.abs(arr[i]-arr[i+1]) !== 1) return false;
  return true;
}

function collectEsthetics(base, range) {
  let out = [], x;
  if (range) {
    for (x = range[0]; x < range[1]; x++)
      if (isEsthetic(x)) out.push(x);
    return out;
  } else {
    x = 1;
    while (out.length < base*6) {
      s = x.toString(base);
      if (isEsthetic(s, base)) out.push(s.toUpperCase());
      x++;
    }
    return out.slice(base*4);
  }
}

// main
let d = new Date();
for (let x = 2; x <= 36; x++) { // we put b17 .. b36 on top, because we can
  console.log(`${x}:`);
  console.log( collectEsthetics(x),
    (new Date() - d) / 1000 + ' s');
}
console.log( collectEsthetics(10, [1000, 9999]),
  (new Date() - d) / 1000 + ' s' );

console.log( collectEsthetics(10, [1e8, 1.3e8]),
  (new Date() - d) / 1000 + ' s' );
