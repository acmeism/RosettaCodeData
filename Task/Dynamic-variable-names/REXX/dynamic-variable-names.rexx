/*REXX program to show use of  dynamic variable names.                  */

parse arg new value
say 'Arguments as they were entered via the command line =' new value
say
call value new,value
say 'The newly assigned value (as per the VALUE bif)------' new value(new)
