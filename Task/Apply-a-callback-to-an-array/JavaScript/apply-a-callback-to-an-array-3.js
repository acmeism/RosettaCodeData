function cube(num) {
  return Math.pow(num, 3);
}

var numbers = [1, 2, 3, 4, 5];

// get results of calling cube on every element
var cubes1 = numbers.map(cube);

// display each result in a separate dialog
cubes1.forEach(alert);

// array comprehension
var cubes2 = [cube(n) for each (n in numbers)];
var cubes3 = [n * n * n for each (n in numbers)];
