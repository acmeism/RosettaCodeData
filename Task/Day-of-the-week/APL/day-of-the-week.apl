⍝ Based on the simplified calculation of Zeller's congruence, since Christmas is after March 1st, no adjustment is required.
⎕IO ← 0              ⍝ Indices are 0-based
y ← 2008 + ⍳114      ⍝ Years from 2008 to 2121
⍝ Simplified Zeller function operating on table of dates formatted as 114 rows and 3 columns of (day, month, year)
⍝ 0 = Saturday, 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday, 5 = Thursday, 6 = Friday
zeller ← { 7 | +/ (((1↑⍴⍵),6)⍴1 1 1 1 ¯1 1) × ⌊(((⍴⍵)⍴1 13 1)×⍵+(⍴⍵)⍴0 1 0)[;0 1 2 2 2 2]÷((1↑⍴⍵),6)⍴1 5 1 4 100 400 }
result ← (1 = zeller 25,[1]12,[0.5]y) / y
