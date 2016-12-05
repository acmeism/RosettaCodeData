function caesar (text, shift) {
  return text.toUpperCase().replace(/[^A-Z]/g,'').replace(/[A-Z]/g, function(a) {
    return String.fromCharCode(65+(a.charCodeAt(0)-65+shift)%26);
  });
}

// Tests
var text = 'veni, vidi, vici';
for (var i = 0; i<26; i++) {
  console.log(i+': '+caesar(text,i));
}
