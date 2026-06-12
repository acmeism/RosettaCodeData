/* GSTrans encoding and decoding */

use std::collections::HashMap;
use std::iter::FromIterator;

/* encoding lookup table */
const ENCODE_TABLE: &[&str] = &[
    "|@",  "|A",  "|B",  "|C",  "|D",  "|E",  "|F", "|G",
    "|H",  "|I",  "|J",  "|K",  "|L",  "|M",  "|N", "|O",
    "|P",  "|Q",  "|R",  "|S",  "|T",  "|U",  "|V", "|W",
    "|X",  "|Y",  "|Z",  "|[",  "|\\", "|]",  "|^", "|_",
    " ",   "!",   "|\"", "#",   "$",   "%",   "&",  "\'",
    "(",   ")",   "*",   "+",   ",",   "-",   ".",  "/",
    "0",   "1",   "2",   "3",   "4",   "5",   "6",  "7",
    "8",   "9",   ":",   ";",   "|<",  "=",   ">",  "?",
    "@",   "A",   "B",   "C",   "D",   "E",   "F",  "G",
    "H",   "I",   "J",   "K",   "L",   "M",   "N",  "O",
    "P",   "Q",   "R",   "S",   "T",   "U",   "V",  "W",
    "X",   "Y",   "Z",   "[",   "\\",  "]",   "^",  "_",
    "`",   "a",   "b",   "c",   "d",   "e",   "f",  "g",
    "h",   "i",   "j",   "k",   "l",   "m",   "n",  "o",
    "p",   "q",   "r",   "s",   "t",   "u",   "v",  "w",
    "x",   "y",   "z",   "{",   "||",  "}",   "~",  "|?",
    "|@", "|!|A","|!|B","|!|C","|!|D","|!|E","|!|F","|!|G",
    "|!|H","|!|I","|!|J","|!|K","|!|L","|!|M","|!|N","|!|O",
    "|!|P","|!|Q","|!|R","|!|S","|!|T","|!|U","|!|V","|!|W",
    "|!|X","|!|Y","|!|Z","|!|[","|!|\\","|!|]","|!|^","|!|_",
    "|! ","|!!","|!|\"", "|!#", "|!$", "|!%", "|!&", "|!\'",
    "|!(","|!)","|!*",   "|!+", "|!,", "|!-", "|!.", "|!/",
    "|!0", "|!1", "|!2", "|!3", "|!4", "|!5", "|!6", "|!7",
    "|!8", "|!9", "|!:", "|!;", "|!|<",  "|!=", "|!>", "|!?",
    "|!@", "|!A", "|!B", "|!C", "|!D", "|!E", "|!F", "|!G",
    "|!H", "|!I", "|!J", "|!K", "|!L", "|!M", "|!N", "|!O",
    "|!P", "|!Q", "|!R", "|!S", "|!T", "|!U", "|!V", "|!W",
    "|!X", "|!Y", "|!Z", "|![", "|!\\","|!]", "|!^", "|!_",
    "|!`", "|!a", "|!b", "|!c", "|!d", "|!e", "|!f", "|!g",
    "|!h", "|!i", "|!j", "|!k", "|!l", "|!m", "|!n", "|!o",
    "|!p", "|!q", "|!r", "|!s", "|!t", "|!u", "|!v", "|!w",
    "|!x", "|!y", "|!z", "|!{", "|!||","|!}", "|!~", "|!|?",
];

// Encode a string into GSTrans form. Will throw an indexing error if a char
// is encountered that does not have integer value >= 0 and <= 255.
fn gs_trans_encode(txt: &str) -> String {
    return txt
        .as_bytes()
        .iter()
        .map(|c| ENCODE_TABLE[*c as usize])
        .collect::<Vec<_>>()
        .join("");
}

// Decode GSTrans coded text. Uses a lookoup table `table`. If table lookup fails
// at any point, will emit a warning to stderr and skip the char at that index.
fn gs_trans_decode(txt: &str, table: &HashMap<&&str, usize>) -> String {
    let mut result = Vec::<u8>::new();
    let mut i = 0;
    let mut substr;
    let mut uppersubstr: String;
    while i < txt.len() {
        let mut foundchar = false;
        let mut decoded = 0_usize;
        for j in 0..5 {
            if i + j > txt.len() {
                break;
            }
            substr = &txt[i..i + j];
            if j == 2 || j == 4 { // match |a as |A in the table
                uppersubstr = substr.to_uppercase();
                substr = &uppersubstr;
            }
            if table.contains_key(&substr) {
                decoded = table[&substr];
                foundchar = true;
                i += j;
                break;
            }
        }
        if foundchar {
            result.push(decoded as u8);
        } else { // error found: skip one char in the bad encoding, so "|1" becomes "1"
            eprintln!("Warning: Bad encoding at position {}, skipped a char", i);
            i += 1;
        }
    }
    return String::from_utf8_lossy(&result).to_string(); // back to utf8 from bytes
}

fn main() {
    // decoding lookup table
    let mut decode_table =
       HashMap::from_iter(ENCODE_TABLE.iter().enumerate().map(|(i, v)| (v, i)));
    for (v, k) in
        [(27, &"|{"), (29, &"|}"), (30, &"|~"), (31, &"|`",),
         (155, &"|!|{"), (157, &"|!|}"), (158, &"|!|~"), (159, &"|!|`",),] {
            decode_table.insert(k, v);
        }
    for test in ["ALERT|G", "wert↑", "@♂aN°$ª7Î", "ÙC▼æÔt6¤☻Ì", "\"@)Ð♠qhýÌÿ",
                       "+☻#o9$u♠©A", "♣àlæi6Ú.é", "ÏÔ♀È♥@ë", "Rç÷\\%◄MZûhZ", "ç>¾AôVâ♫↓P"] {
        let encoded = gs_trans_encode(test);
        let decoded = gs_trans_decode(&encoded, &decode_table);
        println!("Test string {}, encoded: {}, then decoded: {}", test, encoded, decoded);
        assert!(test == decoded);
    }
    for test in [&"|LHello|G|J|M", &"|m|j|@|e|!t|m|!|?", &"abc|1de|5f"] {
        let decoded = gs_trans_decode(test, &decode_table);
        println!("Test string {} decoded is: {}", test, decoded);
    }
}
