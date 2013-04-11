/*REXX pgm displays the name (& possible path) of the REXX program name.*/
parse version _version
parse source _system _howInvoked _path

say right(_version '◄──►' space(arg(1) arg(2)), 79, '─')   /*show title.*/
say "     REXX's name of system being used:"  _system
say '     how the REXX program was invoked:'  _howInvoked
say '    name of the REXX program and path:'  _path

if arg()>1  then return 0              /*don't let this program recurse.*/
                                       /*Mama said that cursing is a sin*/
                                       /*invoke ourself with a  2nd arg.*/
call prog_nam  , 'subroutine'          /*call ourself as a  subroutine. */
zz = prog_nam( , 'function')           /*  "     "     " "  function.   */
                                       /*stick a fork in it, we're done.*/
