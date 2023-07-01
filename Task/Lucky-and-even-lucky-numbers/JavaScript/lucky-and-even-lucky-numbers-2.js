(function() {
  document.write(`
    <table>
      <tr><th>argument(s)<br>space separated</th><th>gives</th></tr>
      <tr><td>$j</td><td><i>j</i><sup>th</sup> lucky number</tr>
      <tr><td>$j lucky</td><td><i>j</i><sup>th</sup> lucky number</tr>
      <tr><td>$j evenLucky</td><td><i>j</i><sup>th</sup> even lucky number</tr>
      <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
      <tr><td>$j $k</td><td><i>J</i><sup>th</sup> through <i>k</i><sup>th</sup> (inclusive) lucky numbers</td></tr>
      <tr><td>$j $k lucky</td><td><i>J</i><sup>th</sup> through <i>k</i><sup>th</sup> (inclusive) lucky numbers</td></tr>
      <tr><td>$j $k evenLucky</td><td><i>J</i><sup>th</sup> through <i>k</i><sup>th</sup> (inclusive) even lucky numbers</td></tr>
      <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
      <tr><td>-$j</td><td>all lucky numbers in the range 1 .. |<i>j</i>|*</tr>
      <tr><td>$j -$k</td><td>all lucky numbers in the range <i>j</i> .. |<i>k</i>|*</tr>
      <tr><td>$j -$k lucky</td><td>all lucky numbers in the range <i>j</i> .. |<i>k</i>|*</tr>
      <tr><td>$j -$k evenLucky</td><td>all even lucky numbers in the range <i>j</i> .. |<i>k</i>|*</tr>
    </table>
    <p>* where |<i>x</i>| is the absolute value of <i>x</i></p>
  `);
  let args = prompt('Enter a luckyNumbers argument string:').split(' '),
      numbers = [],
      strings = [],
      obj = {},      // object to pass to our luckyNumbers function
      msg = '';
  for (let x = 0; x < args.length; x++) {
    if (isNaN(parseInt(args[x]))) strings.push(args[x].toUpperCase());
    else numbers.push(parseInt(args[x]));
  }
  // check strings
  switch (true) {
    case (strings.length > 1):
      msg += 'Too many arguments.';
      break;
    case (strings.length == 0): break;
    case (strings[0] != 'LUCKY' && strings[0] != 'EVENLUCKY'):
      msg += `Unknown argument: ${strings[0]}.`;
      break;
    case (strings[0] == 'EVENLUCKY'): obj.even = true;
  }
  // check numbers
  switch (true) {
    case (numbers.length == 0):
      msg += 'Missing number argument.';
      break;
    case (numbers.length > 2):
      msg += 'Too many number arguments.';
      break;
    case (numbers.length == 1):
      if (numbers[0] > 0) obj.nth = numbers[0];
      else obj.through = Math.abs(numbers[0]);
      break;
    case (numbers.length == 2):
      // both negative
      if (numbers[0] < 0 && numbers[1] < 0) {
        msg += 'Missing positive argument';
        break;
      }
      // negative + positive
      numbers.sort();
      if (numbers[0] < 0 && numbers[1] > 0) {
        obj.range = [numbers[1], Math.abs(numbers[0])];
        break;
      }
      // both positive
      if (numbers[0] > 0 && numbers[1] > 0) {
        obj.through = [numbers[0]-1, numbers[1]];
      }
  }
  if (msg.length > 0)
    document.write(`<p>${msg}<br>Reload to try again</p>`);
  else {
    let res;
    try { res = luckyNumbers(obj); }
    catch (err) {
      document.write(`<p>${err}<br>Reload to try again</p>`);
    }
    finally {
      if (typeof res == 'object' ) res = res.join(', ');
      document.write(`
        <p>
          <b>Input: </b>${args.join(' ')}<br>
          <b>Result: </b>${res}
        </p>
        <p>Reload to continue</p>
      `)
    }
  }
})();
