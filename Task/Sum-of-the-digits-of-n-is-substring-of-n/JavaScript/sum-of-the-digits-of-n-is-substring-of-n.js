function substring_sum(n) {
  const s = String(n);
  const sum = String([...s].map(Number).reduce((x, y) => x + y));
  return s.includes(sum);
}

console.log([...Array(1000).keys()].filter(substring_sum).join(" "));
