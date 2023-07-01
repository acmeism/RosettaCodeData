rgbc=: {{1-x*0>.1<.(<.4&-)6|m+y%60}}
hsv=: 5 rgbc(,"0 1) 3 rgbc(,"0) 1 rgbc
degrees=: {{180p_1*{:"1+.^.y}}
wheel=: {{((1>:|)*|hsv degrees)j./~y%~i:y}}
require'viewmat'
'rgb' viewmat 256#.<.255*wheel 400
