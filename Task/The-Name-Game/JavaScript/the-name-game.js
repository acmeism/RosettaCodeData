function singNameGame(name) {

  // normalize name
  name = name.toLowerCase();
  name = name[0].toUpperCase() + name.slice(1);

  // ... and sometimes y
  // let's pray this works
  let firstVowelPos = (function() {
    let vowels =
      'aeiouàáâãäåæèéêëìíîïòóôõöøùúûüāăąēĕėęěĩīĭįıĳōŏőœũūŭůűų'
    .split('');
    function isVowel(char) {
      return vowels.indexOf(char) >= 0;
    }
    if (isVowel(name[0].toLowerCase())) return 0;
    if (name[0] == 'Y' && !isVowel(name[1])) return 0;
    if (name[0] == 'Y' && isVowel(name[1])) return 1;
    vowels = vowels.concat(vowels, 'yÿý'.split(''));
    for (let i = 1; i < name.length; i++)
      if (isVowel(name[i])) return i;
  })();

  let init  = name[0].toLowerCase(),
      trunk = name.slice(firstVowelPos).toLowerCase(),
      b = trunk, f = trunk, m = trunk;

  switch (init) {
    case 'b': f = 'f' + trunk; m = 'm' + trunk; break;
    case 'f': b = 'b' + trunk; m = 'm' + trunk; break;
    case 'm': b = 'b' + trunk; f = 'f' + trunk; break;
    default: b = 'b' + trunk; f = 'f' + trunk; m = 'm' + trunk;
  }

  return `
    <p>${name}, ${name}, bo-${b}<br>
    Banana-fana fo-${f}<br>
    Fee-fi-fo-mo-${m}<br>
    ${name}!<br></p>
  `
}

// testing
let names =
  'Gary Earl Billy Felix Mary Christine Brian Yvonne Yannick'.split(' ');
for (let i = 0; i < names.length; i++)
  document.write(singNameGame(names[i]));
