function jacobi(n, k) {
  if (k <= 0 || k % 2 !== 1) {
    throw new Error("k must be positive and odd");
  }
  n %= k;
  let t = 1;
  while (n !== 0) {
    while (n % 2 === 0) {
      n /= 2;
      const r = k % 8;
      if (r === 3 || r === 5) {
        t = -t;
      }
    }
    [n, k] = [k, n]; // Swap n and k
    if (n % 4 === 3 && k % 4 === 3) {
      t = -t;
    }
    n %= k;
  }
  return k === 1 ? t : 0;
}

function print_table(out, kmax, nmax) {
  let header = "n\\k|";
  for (let k = 0; k <= kmax; ++k) {
    header += " " + k.toString().padStart(2, ' ');
  }
  out.push(header);

  let separator = "----";
  for (let k = 0; k <= kmax; ++k) {
    separator += "---";
  }
  out.push(separator);

  for (let n = 1; n <= nmax; n += 2) {
    let row = n.toString().padStart(2, ' ') + " |";
    for (let k = 0; k <= kmax; ++k) {
      row += " " + jacobi(k, n).toString().padStart(2, ' ');
    }
    out.push(row);
  }
}

function main() {
  const output = [];
  print_table(output, 20, 21);
  output.forEach(line => console.log(line));
}

main();
