#!/bin/ksh
exec 2> /tmp/Top_rank_per_group.err

# Top rank per group

#	# Variables:
#
integer TOP_NUM=2

typeset -T Empsal_t=(
	typeset -h		'Employee Name'			ename=''
	typeset -h		'Employee ID'			eid=''
	typeset -i -h	'Employee Salary'		esalary
	typeset -h		'Emplyee Department'	edept=''

	function init_employee {
		typeset buff ; buff="$1"

		typeset oldIFS ; oldIFS="$IFS"
		typeset arr ; typeset -a arr
		IFS=\,
		arr=( ${buff} )

		_.ename="${arr[0]}"
		_.eid="${arr[1]}"
		_.esalary=${arr[2]}
		_.edept="${arr[3]}"

		IFS="${oldIFS}"
	}
)

edata='Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190'

 ######
# main #
 ######

#	# Employee data into array of Types
#
typeset -a empsal_t		# array of Type variables (objects)
integer j i=0
echo "${edata}" | while read; do
	Empsal_t empsal_t[i]					# Create Type (object)
	empsal_t[i++].init_employee "$REPLY"	# Initialize Type (object)
done

#	# Sort the array of Type variables
#
set -a -s -A empsal_t -K edept,esalary:n:r,ename

#	# BUG work around! duplicate the now sorted Type array and use it for output
#
sorted=$(typeset -p empsal_t) && sorted=${sorted/empsal_t/sorted} && eval ${sorted}

for ((i=0; i<${#sorted[*]}; i++)); do
	if [[ ${sorted[i].edept} != ${prevdept} ]] || (( j < TOP_NUM )); then
		[[ ${sorted[i].edept} != ${prevdept} ]] && j=0
		print "${sorted[i].edept} ${sorted[i].esalary} ${sorted[i].eid} ${sorted[i].ename}"
		prevdept=${sorted[i].edept}
		(( j++ ))
	fi
done
