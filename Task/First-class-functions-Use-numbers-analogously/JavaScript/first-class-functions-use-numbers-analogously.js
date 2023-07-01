const x = 2.0;
const xi = 0.5;
const y = 4.0;
const yi = 0.25;
const z = x + y;
const zi = 1.0 / (x + y);
const pairs = [[x, xi], [y, yi], [z, zi]];
const testVal = 0.5;

const multiplier = (a, b) => m => a * b * m;

const test = () => {
  return pairs.map(([a, b]) => {
    const f = multiplier(a, b);
    const result = f(testVal);
    return `${a} * ${b} * ${testVal} = ${result}`;
  });
}

test().join('\n');
