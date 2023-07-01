// Least common multiple

function gcd(m: number, n: number): number {
  var tmp: number;
  while (m != 0) {
    tmp = m;
    m = n % m;
    n = tmp;
  }
  return n;
}

function lcm(m: number, n: number): number {
    return Math.floor(m / gcd(m, n)) * n;
}

console.log(`LCM(35, 21) = ${lcm(35, 21)}`);
