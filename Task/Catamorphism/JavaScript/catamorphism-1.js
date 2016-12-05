var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

function add(a, b) {
    return a + b;
}

var summation = nums.reduce(add);

function mul(a, b) {
    return a * b;
}

var product = nums.reduce(mul, 1);

var concatenation = nums.reduce(add, "");

console.log(summation, product, concatenation);
