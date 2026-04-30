function digmul(n) {
  return [...String(n)].reduce((x, y) => Number(x) * Number(y));
}

function mdr_mp(n) {
  let m = n, i = 0;
  while (m > 9) {
    m = digmul(m);
    i++;
  }
  return {"MDR": m, "MP": i};
}

for (const n of [123321, 7739, 893, 899998]) {
  console.log(`${n} has MDR ${mdr_mp(n)["MDR"]} and MP ${mdr_mp(n)["MP"]}`);
}

function first5mdr(n) {
  let m = 0, nums = [];
  while (nums.length < 5) {
    if (mdr_mp(m)["MDR"] == n) {
      nums.push(m);
    }
    m++;
  }
  return `First 5 numbers with MDR ${n}: ${nums.join(", ")}`;
}

for (let i = 0; i < 10; i++) {
  console.log(first5mdr(i));
}
