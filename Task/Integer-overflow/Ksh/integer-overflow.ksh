#!/bin/ksh

# Integer overflow

#	# Variables:
#
typeset -si SHORT_INT
typeset -i  INTEGER
typeset -li LONG_INT

 ######
# main #
 ######

(( SHORT_INT = 2**15 -1 )) ; print "SHORT_INT (2^15 -1) = $SHORT_INT"
(( SHORT_INT = 2**15 )) ; print "SHORT_INT (2^15)   : $SHORT_INT"

(( INTEGER = 2**31 -1 )) ; print "  INTEGER (2^31 -1) = $INTEGER"
(( INTEGER = 2**31 )) ; print "  INTEGER (2^31)   : $INTEGER"

(( LONG_INT = 2**63 -1 )) ; print " LONG_INT (2^63 -1) = $LONG_INT"
(( LONG_INT = 2**63 )) ; print " LONG_INT (2^63)   : $LONG_INT"
