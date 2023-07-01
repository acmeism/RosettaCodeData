function luckyNumbers(opts={}) {
  /**************************************************************************\
  | OPTIONS                                                                  |
  |**************************************************************************|
  |   even ...... boolean ............. return even/uneven numbers           |
  |                                     (default: false)                     |
  |                                                                          |
  |   nth ....... number ............... return nth number                   |
  |                                                                          |
  |   through ... number ............... return numbers from #1 to number    |
  |               OR array[from, to] ... return numbers on index             |
  |                                      from array[from] to array[to]       |
  |                                                                          |
  |   range ..... array[from, to] ...... return numbers between from and to  |
  \**************************************************************************/

  opts.even =  opts.even || false;
  if (typeof opts.through == 'number') opts.through = [0, opts.through];
  let out = [],
      x = opts.even ? 2 : 1,
      max = opts.range ? opts.range[1] * 3
        : opts.through ? opts.through[1] * 12
        : opts.nth ? opts.nth * 15
        : 2000;

  for (x; x <= max; x = x+2) out.push(x);            // fill
  for (x = 1; x < Math.floor(out.length / 2); x++) { // sieve
    let i = out.length;
    while (i--)
      (i+1) % out[x] == 0 && out.splice(i, 1);
  }

  if (opts.nth) return out[opts.nth-1];
  if (opts.through) return out.slice(opts.through[0], opts.through[1]);
  if (opts.range) return out.filter(function(val) {
      return val >= opts.range[0] && val <= opts.range[1];
    });
  return out;
}

/* TESTING */
// blank
console.log( luckyNumbers() );
// showing the first twenty lucky numbers
console.log( luckyNumbers({through: 20}) );
// showing the first twenty even lucky numbers
console.log( luckyNumbers({even: true, through: 20}) );
// showing all lucky numbers between 6,000 and 6,100 (inclusive)
console.log( luckyNumbers({range: [6000, 6100]}) );
// showing all even lucky numbers in the same range as above
console.log( luckyNumbers({even: true, range: [6000, 6100]}) );
// showing the 10,000th lucky number (extra credit)
console.log( luckyNumbers({nth: 10000}) );
// showing the 10,000th even lucky number (extra credit)
console.log( luckyNumbers({even: true, nth: 10000}) );
