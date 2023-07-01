String.prototype.collapse = function() {
  let str = this;
  for (let i = 0; i < str.length; i++) {
    while (str[i] == str[i+1]) str = str.substr(0,i) + str.substr(i+1);
  }
  return str;
}

// testing
let strings = [
  '',
  '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
  '..1111111111111111111111111111111111111111111111111111111111111117777888',
  `I never give 'em hell, I just tell the truth, and they think it's hell. `,
  '                                                    --- Harry S Truman  '
];
for (let i = 0; i < strings.length; i++) {
  let str = strings[i], col = str.collapse();
  console.log(`«««${str}»»» (${str.length})`);
  console.log(`«««${col}»»» (${col.length})`);
}
