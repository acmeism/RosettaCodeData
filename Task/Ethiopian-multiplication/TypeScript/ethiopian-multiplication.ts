// Ethiopian multiplication

function double(a: number): number {
  return 2 * a;
}

function halve(a: number): number {
  return Math.floor(a / 2);
}

function isEven(a: number): bool {
  return a % 2 == 0;
}

function showEthiopianMultiplication(x: number, y: number): void {
  var tot = 0;
  while (x >= 1) {
    process.stdout.write(x.toString().padStart(9, ' ') + " ");
    if (!isEven(x)) {
      tot += y;
      process.stdout.write(y.toString().padStart(9, ' '));
    }
    console.log();
    x = halve(x);
    y = double(y);
  }
  console.log("=" + " ".repeat(9) + tot.toString().padStart(9, ' '));
}

showEthiopianMultiplication(17, 34);
