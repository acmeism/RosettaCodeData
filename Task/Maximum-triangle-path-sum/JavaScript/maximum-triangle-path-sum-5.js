function maximumTrianglePathSum(triangle) {

  function distilLastLine() {
    let lastLine = triangle.pop(),
        aboveLine = triangle.pop();
    for (let i = 0; i < aboveLine.length; i++)
      aboveLine[i] = Math.max(
        aboveLine[i] + lastLine[i],
        aboveLine[i] + lastLine[i + 1]
      );
    triangle.push(aboveLine);
  }

  do {
    distilLastLine();
  } while (triangle.length > 1);
  return triangle[0][0];
}

// testing
let theTriangle = [
[55],
[94, 48],
[95, 30, 96],
[77, 71, 26, 67],
[97, 13, 76, 38, 45],
[ 7, 36, 79, 16, 37, 68],
[48,  7,  9, 18, 70, 26,  6],
[18, 72, 79, 46, 59, 79, 29, 90],
[20, 76, 87, 11, 32,  7,  7, 49, 18],
[27, 83, 58, 35, 71, 11, 25, 57, 29, 85],
[14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55],
[ 2, 90,  3, 60, 48, 49, 41, 46, 33, 36, 47, 23],
[92, 50, 48,  2, 36, 59, 42, 79, 72, 20, 82, 77, 42],
[56, 78, 38, 80, 39, 75,  2, 71, 66, 66,  1,  3, 55, 72],
[44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36],
[85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17,  1,  1, 99, 89, 52],
[ 6, 71, 28, 75, 94, 48, 37, 10, 23, 51,  6, 48, 53, 18, 74, 98, 15],
[27,  2, 92, 23,  8, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93]
];

console.log(maximumTrianglePathSum(theTriangle));
