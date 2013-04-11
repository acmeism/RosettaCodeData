>>> var array = [2, 4, 5, 13, 18, 24, 34, 97];
>>> array
[2, 4, 5, 13, 18, 24, 34, 97]

// return all elements less than 10
>>> array.filter(function (x) { return x < 10 });
[2, 4, 5]

// return all elements less than 30
>>> array.filter(function (x) { return x < 30 });
[2, 4, 5, 13, 18, 24]

// return all elements less than 100
>>> array.filter(function (x) { return x < 100 });
[2, 4, 5, 13, 18, 24, 34, 97]

// multiply each element by 2 and return the new array
>>> array.map(function (x) { return x * 2 });
[4, 8, 10, 26, 36, 48, 68, 194]

// sort the array from smallest to largest
>>> array.sort(function (a, b) { return a > b });
[2, 4, 5, 13, 18, 24, 34, 97]

// sort the array from largest to smallest
>>> array.sort(function (a, b) { return a < b });
[97, 34, 24, 18, 13, 5, 4, 2]
