Identification division.
  Program-ID. The-Name-Game.
Data division.
  Working-storage section.
    01 name pic X(15).
    01 lowercase-name pic X(15).
    01 first-character pic X.
    01 truncated-name pic X(15).
    01 vowel-check pic 9.
      88 name-starts-with-vowel value 1.
    01 b pic X value "b".
    01 f pic X value "f".
    01 m pic X value "m".
Procedure division.
  Display "Name: " with no advancing.
  Accept name.
  Move function lower-case(name) to lowercase-name.
  Move lowercase-name(1:1) to first-character.
  Move lowercase-name(2:) to truncated-name.
  Inspect "aeiou" tallying vowel-check for all first-character.
  If name-starts-with-vowel then move lowercase-name to truncated-name.
  If first-character is equal to "b" then move "" to b.
  If first-character is equal to "f" then move "" to f.
  If first-character is equal to "m" then move "" to m.
  Display function trim(name) ", " function trim(name) ", bo-" function trim(b) truncated-name.
  Display "Banana-fana fo-" function trim(f) truncated-name.
  Display "Fee-fi-mo-" function trim(m) truncated-name.
  Display function trim(name) "!".
