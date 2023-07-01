/*REXX program demonstrates null strings, and also undefined values. */

if symbol('ABC')=="VAR" then say 'variable ABC is defined, value='abc"<<<"
                        else say "variable ABC isn't defined."
xyz=47
if symbol('XYZ')=="VAR" then say 'variable XYZ is defined, value='xyz"<<<"
                        else say "variable XYZ isn't defined."
drop xyz
if symbol('XYZ')=="VAR" then say 'variable XYZ is defined, value='xyz"<<<"
                        else say "variable XYZ isn't defined."
cat=''
if symbol('CAT')=="VAR" then say 'variable CAT is defined, value='cat"<<<"
                        else say "variable CAT isn't defined."
