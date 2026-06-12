function has_dec(n) {
  return n.toString(16).match(/[0-9]/);
}

let hexnums = [];
for (let i = 1; i < 500; i++) {
  if (!has_dec(i)) {
    hexnums.push(i);
  }
}
console.log(hexnums.join(" "));
