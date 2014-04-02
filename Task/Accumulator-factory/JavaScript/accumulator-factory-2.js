let accumulator = sum => (n => sum += n);
let x = accumulator(1);
console.log(x(5));
accumulator(3);
console.log(x(2.3));
