/*REXX program displays the  word      SPAM      forever.               */

tell_it:    say 'SPAM'

signal tell_it                         /*REXX's version of a  GO TO     */

                                       /*control will never reach here. */
                                       /*don't stick a fork in it.      */
