seg=: [ + [: +/\ (0,1r3*1,(^j.(,-)_2 o.1r2),1) * -~
koch=: [: ,/ 2 seg/\ ]

require'plot'
tri=: ^ j. 4r3 * (_2 o. 0) * i._4
plot koch ^: 5 tri
