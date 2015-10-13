zz= 'llo world!'          /*─────────────── using literal abuttal.────────────*/
zz= 'he'zz                /*This won't work if the variable name is  X  or  B */
say zz


gg = "llo world!"         /*─────────────── using literal concatenation.──────*/
gg = 'he' || gg
say gg


aString= 'llo world!'     /*─────────────── using variable concatenation.─────*/
bString= "he"
aString= bString || aString
say aString
