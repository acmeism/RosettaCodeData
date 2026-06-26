const parseRomanNumeral = (() => {
    const numerals = [
      ['M', 1000],
      ['CM', 900],
      ['D', 500],
      ['CD', 400],
      ['C', 100],
      ['XC', 90],
      ['L', 50],
      ['XL', 40],
      ['X', 10],
      ['IX', 9],
      ['V', 5],
      ['IV', 4],
      ['I', 1],
    ];

  return function (str) {
    let result = 0;
    let i = 0;

    for (const [numeral, value] of numerals) {
      while (str.indexOf(numeral, i) === i) {
        result += value;
        i += numeral.length;
      }
    }

    // invalid roman numeral
    if (i !== str.length) {
      return NaN;
    }

    return result;
  }
})();

const numerics = ["MMXVI", "MCMXC", "MMVIII", "MM", "MDCLXVI"]
    .map(parseRomanNumeral);

console.log(numerics);
