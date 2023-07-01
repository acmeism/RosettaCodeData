# syntax: GAWK -f HALT_AND_CATCH_FIRE.AWK
#
# This won't halt the CPU but the program will crash immediately on startup
# with "error: division by zero attempted".
BEGIN { 1/0 }
#
# This will heat up the CPU, don't think it will catch on fire.
BEGIN { while(1) {} }
#
# Under TAWK 5.0 using AWKW will immediately abort.
BEGIN { abort(1) }
