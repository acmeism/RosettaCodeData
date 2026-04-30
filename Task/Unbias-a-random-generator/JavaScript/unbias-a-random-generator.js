const randN = N => () => Math.floor(Math.random() * N) === 0;

function unbiased(f) {
  let x, y;
  do {
    x = f(), y = f();
  } while (x === y);
  return x;
}

for (let i = 3; i <= 6; i++) {
  const biased = randN(i);
  let b = [], ub = [];
  for (let j = 0; j < 10000; j++) {
    b.push(biased());
    ub.push(unbiased(biased));
  }
  const onecounts = [b, ub].map(a => a.filter(x => x).length / 100);
  console.log(`N = ${i}: biased ${onecounts[0]}% ones, unbiased ${onecounts[1]}% ones`);
}
