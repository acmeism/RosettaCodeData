/*REXX program demonstrates a use of a special case of inverted syntax  (via SIGNAL ON).*/
signal on syntax
a=7
zz=444 / (7-a)
return zz
/*──────────────────────────────────────────────────────────────────────────────────────*/
syntax:  say  '***error***  program is attempting to do division by zero,'
         say  'the REXX statement number is: '  sigL  " and the REXX source is:"
         say  sourceLine(sigL)
         exit 13
