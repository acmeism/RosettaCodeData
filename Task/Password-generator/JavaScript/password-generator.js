String.prototype.shuffle = function() {
  return this.split('').sort(() => Math.random() - .5).join('');
}

function createPwd(opts = {}) {
  let len    = opts.len || 5,                       // password length
      num    = opts.num || 1,                       // number of outputs
      noSims = opts.noSims == false ? false : true, // exclude similar?
      out = [],
      cur, i;

  let chars = [
    'abcdefghijkmnopqrstuvwxyz'.split(''),
    'ABCDEFGHJKLMNPQRTUVWXY'.split(''),
    '346789'.split(''),
    '!"#$%&()*+,-./:;<=>?@[]^_{|}'.split('')
  ];

  if (!noSims) {
    chars[0].push('l');
    chars[1] = chars[1].concat('IOSZ'.split(''));
    chars[2] = chars[2].concat('1250'.split(''));
  }

  if (len < 4) {
    console.log('Password length changed to 4 (minimum)');
    len = 4;
  }

  while (out.length < num) {
    cur = '';
    // basic requirement
    for (i = 0; i < 4; i++)
      cur += chars[i][Math.floor(Math.random() * chars[i].length)];

    while (cur.length < len) {
      let rnd = Math.floor(Math.random() * chars.length);
      cur += chars[rnd][Math.floor(Math.random() * chars[rnd].length)];
    }
    out.push(cur);
  }

  for (i = 0; i < out.length; i++) out[i] = out[i].shuffle();

  if (out.length == 1) return out[0];
  return out;
}

// testing
console.log( createPwd() );
console.log( createPwd( {len: 20}) );
console.log( createPwd( {len: 20, num: 2}) );
console.log( createPwd( {len: 20, num: 2, noSims: false}) );
