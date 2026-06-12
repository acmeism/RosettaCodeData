/*REXX program detects  whether or not  it is a  "scripted main"  program.              */
parse source . howInvoked @fn                    /*query REXX how this pgm got invoked. */

say 'This program  ('@fn")  was invoked as a: "    howInvoked

if howInvoked\=='COMMAND'  then do
                                say 'This program  ('@fn")  wasn't invoked via a command."
                                exit 12
                                end

    /*╔════════════════════════════════════════════════════════════════════════════════╗
      ║  At this point, we know that this program was invoked via the  "command line"  ║
      ║  or a program using the  "command interface"  and  not  via another program.   ║
      ╚════════════════════════════════════════════════════════════════════════════════╝*/

/*────────────────────────────── The main code follows here ... ────────────────────────*/
say
say '(from' @fn"):  and away we go ···"
