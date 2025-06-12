const MAX_N = 20
const TIMES = 1000000

function factorial(n) {
    let prod = 1;
    for (let i = n; i > 1; i--) {
        prod *= i;
    }
    return prod;
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}


function analytical(n) {
    let items = [];

    for (let i = 1; i < n+1; i++) {
        items.push(factorial(n) / Math.pow(n, i) / factorial(n - i));
    }

    return items.reduce((p, v) => p + v, 0);
}

function test(n, times) {
    let count = 0;
    for (let i = 0; i < times; i++) {
        let x = 1, bits = 0;

        while (!(bits & x)) {
            count += 1;
            bits |= x;
            x = 1 << getRandomInt(0, n-1);
        }
    }
    return count / times;
}

console.log(" n\tavg\texp.\tdiff\n-------------------------------");
for(let n = 1; n < MAX_N+1; n++) {
    const avg = test(n, TIMES);
    const theory = analytical(n);
    const diff = (avg / theory - 1) * 100;
    console.log(`${n.toString().padStart(2)} ${avg.toFixed(4).padStart(8)} ${theory.toFixed(4).padStart(8)} ${diff.toFixed(3).padStart(6)}%`);
}
