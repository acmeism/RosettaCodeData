#!/bin/ksh

# Print debugging statement

#	# Variables:
#
typeset -C clr		# Colours
	clr.lin='�[1;7;33m'	# Line number
	clr.cmd='�[1;36m'		# Command
	clr.out='�[1m'			# Output
	clr.rst='�[0m'			# ANSI reset

alias D_WRITE='print -u2'	# to stderr (2)

#	# Functions:
#

#	# Function _debug() - print some debug info to stderr
#
function _debug {
	D_WRITE -n "${clr.lin}Line ${.sh.lineno}:${clr.rst} "
	D_WRITE "${clr.cmd}Command: '${.sh.command}'${clr.rst}"
	[[ -n ${x} ]] && D_WRITE "	${clr.out}x=${x}${clr.rst}"
	[[ -n ${y} ]] && D_WRITE "	${clr.out}y=${y}${clr.rst}"
	[[ -n ${result} ]] && D_WRITE "	${clr.out}result=${result}${clr.rst}"
}

 ######
# main #
 ######
trap _debug DEBUG	# Call _debug() on DEBUG trap (i.e. every line)

integer x y result
x=1
y=5
(( result = x + y ))
exit
