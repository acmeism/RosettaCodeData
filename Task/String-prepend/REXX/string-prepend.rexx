                        /*──────────────── using literal abuttal.       */
                        /*──────────────── this won't work as the first */
                        /*──────────────── variable name is   X  or  B  */
zz='llo world!'
zz='he'zz
say zz

                        /*──────────────── using literal concatenation. */
gg = "llo world!"
gg = 'he' || gg
say gg

                        /*──────────────── using variable concatenation.*/
aString = 'llo world!'
bString = "he"
aString = bString || aString
say aString
