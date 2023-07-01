String extend [
  copyFrom: index length: nChar [
    ^ self copyFrom: index to: ( index + nChar - 1 )
  ]
  copyFromRegex: regEx length: nChar [
    |i|
    i := self indexOfRegex: regEx.
    ^ self copyFrom: (i first) length: nChar
  ]
].

"and show it simpler..."

(s copyFrom: 13 length: 5) displayNl.
(s copyFromRegex: 'w' length: 5) displayNl.
(s copyFromRegex: 'ro' length: 3) displayNl.
