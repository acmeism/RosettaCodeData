/*****************************************************************\
| Expects an angle, an origin unit and a unit to convert to,      |
| where in/out units are:                                         |
| --------------------------------------------------------------- |
| 'D'/'d' ..... degrees             'M'/'d' ..... mils            |                                          |
| 'G'/'g' ..... gradians            'R'/'r' ..... radians         |
| --------------------------------------------------------------- |
| example: convert 150 degrees to radians:                        |
| angleConv(150, 'd', 'r')                                        |
\*****************************************************************/
function angleConv(deg, inp, out) {
  inp = inp.toLowerCase();
  out = out.toLowerCase();
  const D = 360,
        G = 400,
        M = 6400,
        R = 2 * Math.PI;
  // normalazation
  let minus = (deg < 0);  // boolean
  deg = Math.abs(deg);
  switch (inp) {
    case 'd': deg %= D; break;
    case 'g': deg %= G; break;
    case 'm': deg %= M; break;
    case 'r': deg %= R;
  }
  // we use an internal conversion to Turns (full circle) here
  let t;
  switch (inp) {
    case 'd': t = deg / D; break;
    case 'g': t = deg / G; break;
    case 'm': t = deg / M; break;
    case 'r': t = deg / R;
  }
  // converting
  switch (out) {
    case 'd': t *= D; break;
    case 'g': t *= G; break;
    case 'm': t *= M; break;
    case 'r': t *= R;
  }
  if (minus) return 0 - t;
  return t;
}

// mass testing
let nums  = [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1e6],
    units = 'dgmr'.split(''),
    x, y, z;
for (x = 0; x < nums.length; x++) {
  for (y = 0; y < units.length; y++) {
    document.write(`
      <p>
        <b>${nums[x]}<sub>${units[y]}</sub></b><br>
    `);
    for (z = 0; z < units.length; z++)
      document.write(`
        = ${angleConv(nums[x], units[y], units[z])}<sub>${units[z]}</sub>
      `);
  }
}
