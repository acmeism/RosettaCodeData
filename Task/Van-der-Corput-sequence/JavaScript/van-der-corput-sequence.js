function vdc(n) {
  const bits = [...n.toString(2)].toReversed();
  const exps = [...Array(bits.length).keys()].map(x => -x);
  let res = 0;
  for (let i = 0; i < bits.length; i++) {
    res += bits[i] * 2 ** (exps[i] - 1);
  }
  return res;
}

console.log([...Array(10).keys()].map(vdc).join(" "));
