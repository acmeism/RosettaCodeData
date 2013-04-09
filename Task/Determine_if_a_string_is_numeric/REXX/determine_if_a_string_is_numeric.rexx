/*REXX program to determine if a string is numeric. */
yyy=' -123.78'               /*or some such.*/

                             /*strings below are all numeric (REXX).*/
zzz=' -123.78 '
zzz='-123.78'
zzz='2'
zzz="2"
zzz=2
zzz='000000000004'
zzz='+5'
zzz=' +6 '
zzz=' + 7 '
zzz=' - 8 '
zzz=' - .9'
zzz='- 19.'
zzz='.7'
zzz='2e3'
zzz=47e567
zzz='2e-3'
zzz='1.2e1'
zzz=' .2E6'
zzz=' 2.e5 '
zzz='       +1.2E0002 '
zzz='       +1.2e+002 '
zzz=' +0000001.200e+002 '
zzz=' - 000001.200e+002 '
zzz=' - 000008.201e-00000000000000002 '

/*Note:  some REXX interpreters allow use of tab chars as blanks.  */

                             /*all statements below are equivalent.*/

if \datatype(yyy,'n')       then say 'oops, not numeric:' yyy
if \datatype(yyy,'N')       then say 'oops, not numeric:' yyy
if Â¬datatype(yyy,'N')       then say 'oops, not numeric:' yyy
if Â¬datatype(yyy,'numeric') then say 'oops, not numeric:' yyy
if Â¬datatype(yyy,'nimrod.') then say 'oops, not numeric:' yyy
if  datatype(yyy)\=='NUM'   then say 'oops, not numeric:' yyy
if  datatype(yyy)/=='NUM'   then say 'oops, not numeric:' yyy
if  datatype(yyy)Â¬=='NUM'   then say 'oops, not numeric:' yyy
if  datatype(yyy)Â¬= 'NUM'   then say 'oops, not numeric:' yyy

/*note: REXX only looks at the first char for DATATYPE's  2nd arg. */

/*note: some REXX interpreters don't support the Â¬ (not) character.*/
