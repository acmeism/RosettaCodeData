#!/bin/ksh

# RPG attributes generator

#	# Variables:
#
typeset -a attribs=( strength dexterity constitution intelligence wisdom charisma )
integer MINTOT=75 MIN15S=2

#	# Functions:
#
#   # Function _diceroll(sides, number, reportAs) - roll number of side-sided
#   # dice, report (s)sum or (a)array (pseudo) of results
#
function _diceroll {
  typeset _sides    ; integer _sides=$1         # Number of sides of dice
  typeset _numDice  ; integer _numDice=$2       # Number of dice to roll
  typeset _rep      ; typeset -l -L1 _rep="$3"  # Report type: (sum || array)

  typeset _seed    ; (( _seed = SECONDS / $$ )) ; _seed=${_seed#*\.}
  typeset _i _sum  ; integer _i _sum=0
  typeset _arr     ; typeset -a _arr

  RANDOM=${_seed}
  for (( _i=0; _i<_numDice; _i++ )); do
      (( _arr[_i] = (RANDOM % _sides) + 1 ))
      [[ ${_rep} == s ]] && (( _sum += _arr[_i] ))
  done

    if [[ ${_rep} == s ]]; then
      echo ${_sum}
    else
      echo "${_arr[@]}"
    fi
}

#	# Function _sumarr(n arr) - Return the sum of the first n arr elements
#
function _sumarr {
	typeset _n ; integer _n=$1
	typeset _arr ; nameref _arr="$2"
	typeset _i _sum ; integer _i _sum

	for ((_i=0; _i<_n; _i++)); do
		(( _sum+=_arr[_i] ))
	done
	echo ${_sum}
}

 ######
# main #
 ######

until (( total >= MINTOT )) && (( cnt15 >= MIN15S )); do
	integer total=0 cnt15=0
	unset attrval ; typeset -A attrval
	for attr in ${attribs[*]}; do
		unset darr ; typeset -a darr=( $(_diceroll 6 4 a) )
		set -sK:nr -A darr
		attrval[${attr}]=$(_sumarr 3 darr)
		(( total += attrval[${attr}] ))
		(( attrval[${attr}] > 14 )) && (( cnt15++ ))
	done
done

for attr in ${attribs[*]}; do
	printf "%12s: %2d\n" ${attr} ${attrval[${attr}]}
done
print "Attribute value total: ${total}"
print "Attribule count >= 15:  ${cnt15}"
