const left_rect = (f, x, h) => f(x);
const right_rect = (f, x, h) => f(x + h);
const mid_rect = (f, x, h) => f(x + h / 2);
const trapezium = (f, x, h) => (f(x) + f(x + h)) / 2;
const simpson = (f, x, h) => (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6;

function integrate(f, a, b, n, rule) {
  const h = (b - a) / n;
  let result = 0;
  for (let i = 0; i < n; i++) {
    result += rule(f, a + i * h, h);
  }
  return h * result;
}

function integral_test(f, a, b, n) {
  console.log(`Integrating ${f.toString()} from ${a} to ${b} with ${n} steps...`);
  const rules = {"Left rectangular method": left_rect,
               "Right rectangular method": right_rect,
               "Midpoint rectangular method": mid_rect,
               "Trapezium rule": trapezium,
               "Simpson's rule": simpson};

  for (const r in rules) {
    console.log(`${r}: ${integrate(f, a, b, n, rules[r])}`);
  }
  console.log();
}

integral_test(x => x ** 3, 0, 1, 100);
integral_test(x => 1 / x, 1, 100, 1000);
integral_test(x => x, 0, 5000, 5000000);
integral_test(x => x, 0, 6000, 6000000);
