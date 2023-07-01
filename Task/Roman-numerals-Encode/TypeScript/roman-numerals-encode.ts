// Roman numerals/Encode

const weightsSymbols: [number, string][] =
  [[1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'], [100, 'C'], [90, 'XC'],
  [50, 'L'], [40, 'XL'], [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I']];
// 3888 or MMMDCCCLXXXVIII (15 chars) is the longest string properly encoded
// with these symbols.

function toRoman(n: number): string {
  var roman = ""; // Result
  for (i = 0; i <= 12 && n > 0; i++) {
    var w = weightsSymbols[i][0];
    while (n >= w) {
      roman += weightsSymbols[i][1];
      n -= w;
    }
  }
  return roman;
}

console.log(toRoman(1990)); // MCMXC
console.log(toRoman(2022)); // MMXXII
console.log(toRoman(3888)); // MMMDCCCLXXXVIII
