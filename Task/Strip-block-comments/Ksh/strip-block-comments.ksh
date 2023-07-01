#!/bin/ksh

# Strip block comments

#	# Variables:
#
bd=${1:-'/*'}
ed=${2:-'*/'}

testcase='/**
 * Some comments
 * longer comments here that we can parse.
 *
 * Rahoo
 */
 function subroutine() {
 a = /* inline comment */ b + c ;
 }
 /*/ <-- tricky comments */

 /**
 * Another comment.
 */
 function something() {
 }'

 ######
# main #
 ######

testcase=${testcase%%"${bd}"*}
while [[ -n ${.sh.match} ]]; do		# .sh.match stores the most recent match
	if [[ -n ${testcase} ]]; then
		sm="${.sh.match}"
		sm="${sm/"${bd}"/}"
		buff="${testcase}"
		buff+="${sm#*"${ed}"}"
		testcase="${buff}"
	else
		testcase="${.sh.match}"
		testcase="${testcase#*"${ed}"}"
	fi
	testcase=${testcase%%"${bd}"*}
done

echo "${testcase}"
