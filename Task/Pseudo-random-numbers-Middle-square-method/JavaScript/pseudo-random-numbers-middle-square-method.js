let seed = 675248;

function middlesquare() {
  let s = String(seed ** 2);
  if (s.length < 12) {
    s = s.padStart(12, "0");
  }
  seed = Number(s.substring(3, 9));
  return seed;
}

for (let i = 0; i < 5; i++) {
  console.log(middlesquare());
}
