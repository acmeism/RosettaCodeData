let prod = 1, sum = 0;
const x = 5, y = -5, z = -2;
const one = 1, three = 3, seven = 7;

function process(j) {
  sum += Math.abs(j);
  if (Math.abs(prod) < 2 ** 27 && j !== 0) {
    prod *= j;
  }
}

function multifor(f, arr) {
  function wraploop(start, stop, step = 1) {
    for (let j = start; Math.abs(j) <= Math.abs(stop); j += step) {
      f(j);
    }
  }
  for (const subarr of arr) {
    wraploop(...subarr);
  }
}

const test_ranges = [[-three, 3 ** 3, three],
                     [-seven, seven, x],
                     [555, 550 - y],
                     [22, -28, -three],
                     [1927, 1939],
                     [x, y, z],
                     [11 ** x, 11 ** x + one]];

multifor(process, test_ranges);
console.log(`Sum: ${sum}`);
console.log(`Product: ${prod}`);
