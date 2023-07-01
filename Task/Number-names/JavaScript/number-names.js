const divMod = y => x => [Math.floor(y/x), y % x];

const sayNumber = value => {
  let name = '';
  let quotient, remainder;
  const dm = divMod(value);
  const units = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven',
    'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen',
    'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
  const tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty',
    'seventy', 'eighty', 'ninety'];
  const big = [...['', 'thousand'], ...['m', 'b', 'tr', 'quadr', 'quint',
    'sext', 'sept', 'oct', 'non', 'dec'].map(e => `${e}illion`)];

  if (value < 0) {
    name = `negative ${sayNumber(-value)}`
  } else if (value < 20) {
    name = units[value]
  } else if (value < 100) {
    [quotient, remainder] = dm(10);
    name = `${tens[quotient]} ${units[remainder]}`.replace(' zero', '');
  } else if (value < 1000) {
    [quotient, remainder] = dm(100);
    name = `${sayNumber(quotient)} hundred and ${sayNumber(remainder)}`
      .replace(' and zero', '')
  } else {
    const chunks = [];
    const text = [];
    while (value !== 0) {
      [value, remainder] = divMod(value)(1000);
      chunks.push(remainder);
    }
    chunks.forEach((e,i) => {
      if (e > 0) {
        text.push(`${sayNumber(e)}${i === 0 ? '' : ' ' + big[i]}`);
        if (i === 0 && e < 100) {
          text.push('and');
        }
      }
    });
    name = text.reverse().join(', ').replace(', and,', ' and');
  }
  return name;
};
