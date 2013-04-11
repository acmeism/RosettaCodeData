|s|
s := 'hello world shortest program'.

(s copyFrom: 13 to: (13+4)) displayNl.
"4 is the length (5) - 1, since we need the index of the
 last char we want, which is included"

(s copyFrom: 7) displayNl.
(s allButLast) displayNl.

(s copyFrom: ((s indexOfRegex: 'w') first)
   to: ( ((s indexOfRegex: 'w') first) + 4) ) displayNl.
(s copyFrom: ((s indexOfRegex: 'ro') first)
   to: ( ((s indexOfRegex: 'ro') first) + 2) ) displayNl.
