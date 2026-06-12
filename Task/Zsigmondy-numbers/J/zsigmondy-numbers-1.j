dp=: -/@:(^/) NB. (a,b) dp n  is (a^n)-(b^n)
Zsigmondy=: dp (-.,)&.:q: (dp 1 }. i.)
