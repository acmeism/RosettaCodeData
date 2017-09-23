(function (p) {
  return [
    p.split('').reverse().join(''),

    p.split(' ').map(function (x) {
        return x.split('').reverse().join('');
    }).join(' '),

    p.split(' ').reverse().join(' ')

  ].join('\n');

})('rosetta code phrase reversal');
