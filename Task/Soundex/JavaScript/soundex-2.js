function soundex(t) {
  t = t.toUpperCase().replace(/[^A-Z]/g, '');
  return (t[0] || '0') + t.replace(/[HW]/g, '')
    .replace(/[BFPV]/g, '1')
    .replace(/[CGJKQSXZ]/g, '2')
    .replace(/[DT]/g, '3')
    .replace(/[L]/g, '4')
    .replace(/[MN]/g, '5')
    .replace(/[R]/g, '6')
    .replace(/(.)\1+/g, '$1')
    .substr(1)
    .replace(/[AEOIUHWY]/g, '')
    .concat('000')
    .substr(0, 3);
}

// tests
[ ["Example", "E251"], ["Sownteks", "S532"], ["Lloyd", "L300"], ["12346", "0000"],
 ["4-H", "H000"], ["Ashcraft", "A261"], ["Ashcroft", "A261"], ["auerbach", "A612"],
 ["bar", "B600"], ["barre", "B600"], ["Baragwanath", "B625"], ["Burroughs", "B620"],
 ["Burrows", "B620"], ["C.I.A.", "C000"], ["coöp", "C100"], ["D-day", "D000"],
 ["d jay", "D200"], ["de la Rosa", "D462"], ["Donnell", "D540"], ["Dracula", "D624"],
 ["Drakula", "D624"], ["Du Pont", "D153"], ["Ekzampul", "E251"], ["example", "E251"],
 ["Ellery", "E460"], ["Euler", "E460"], ["F.B.I.", "F000"], ["Gauss", "G200"],
 ["Ghosh", "G200"], ["Gutierrez", "G362"], ["he", "H000"], ["Heilbronn", "H416"],
 ["Hilbert", "H416"], ["Jackson", "J250"], ["Johnny", "J500"], ["Jonny", "J500"],
 ["Kant", "K530"], ["Knuth", "K530"], ["Ladd", "L300"], ["Lloyd", "L300"],
 ["Lee", "L000"], ["Lissajous", "L222"], ["Lukasiewicz", "L222"], ["naïve", "N100"],
 ["Miller", "M460"], ["Moses", "M220"], ["Moskowitz", "M232"], ["Moskovitz", "M213"],
 ["O'Conner", "O256"], ["O'Connor", "O256"], ["O'Hara", "O600"], ["O'Mally", "O540"],
 ["Peters", "P362"], ["Peterson", "P362"], ["Pfister", "P236"], ["R2-D2", "R300"],
 ["rÄ≈sumÅ∙", "R250"], ["Robert", "R163"], ["Rupert", "R163"], ["Rubin", "R150"],
 ["Soundex", "S532"], ["sownteks", "S532"], ["Swhgler", "S460"], ["'til", "T400"],
 ["Tymczak", "T522"], ["Uhrbach", "U612"], ["Van de Graaff", "V532"],
 ["VanDeusen", "V532"], ["Washington", "W252"], ["Wheaton", "W350"],
 ["Williams", "W452"], ["Woolcock", "W422"]
].forEach(function(v) {
  var a = v[0], t = v[1], d = soundex(a);
   if (d !== t) {
    console.log('soundex("' + a + '") was ' + d + ' should be ' + t);
  }
});
