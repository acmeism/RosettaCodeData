function caesar (text, shift) {
  return text.toUpperCase().replace(/[^A-Z]/g,'').replace(/./g, function(a) {
    return String.fromCharCode(((a.charCodeAt(0) - 65 + shift) % 26 + 26) % 26 + 65);
  });
}

// Tests
var text = 'veni, vidi, vici';
for (var i = 0; i<26; i++) {
  console.log(i+': '+caesar(text,i));
}
