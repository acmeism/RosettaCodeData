const lunhCheck = (str) => {
    const sumDigit = (c) => (c < 10) ? c :
              sumDigit( Math.trunc(c / 10) + (c % 10));

    return str.split('').reverse()
              .map(Number)
              .map((c, i) => i % 2 !== 0 ? sumDigit(c * 2) : c)
              .reduce((acc,v) => acc + v) % 10 === 0;
};

lunhCheck('49927398716'); // returns true
lunhCheck('49927398717'); // returns false
lunhCheck('1234567812345678'); // returns false
lunhCheck('1234567812345670'); // returns true
