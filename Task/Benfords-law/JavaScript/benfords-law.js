const fibseries = n => [...Array(n)].reduce((fib, _, i) => i < 2 ? fib : fib.concat(fib[i - 1]+fib[i - 2]), [1, 1]);
const benford = array => [1, 2, 3, 4, 5, 6, 7, 8, 9].map( val => [val, array.reduce((sum, item) => sum + (`${item}`[0] === `${val}`), 0) / array.length, Math.log10(1 + 1 / val)]);
console.log(benford(fibseries(1000)))
