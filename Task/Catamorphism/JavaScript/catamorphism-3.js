var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

console.log(nums.reduce((a, b) => a + b, 0)); // sum of 1..10
console.log(nums.reduce((a, b) => a * b, 1)); // product of 1..10
console.log(nums.reduce((a, b) => a + b, '')); // concatenation of 1..10
