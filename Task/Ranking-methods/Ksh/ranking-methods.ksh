#!/bin/ksh
exec 2> /tmp/Ranking_methods.err
# Ranking methods
#
#	# Standard. (Ties share what would have been their first ordinal number).
#	# Modified. (Ties share what would have been their last ordinal number).
#	# Dense. (Ties share the next available integer).
#	# Ordinal. ((Competitors take the next available integer. Ties are not treated otherwise).
#	# Fractional. (Ties share the mean of what would have been their ordinal numbers)

#	# Variables:
#
typeset -a arr=( '44 Solomon' '42 Jason' '42 Errol' '41 Garry' '41 Bernard' '41 Barry' '39 Stephen' )
integer i

#	# Functions:
#

#	# Function _rankStandard(arr, rankarr) - retun arr with standard ranking
#
function _rankStandard {
	typeset _ranked ; nameref _ranked="$1"

	typeset _i _j _scr _currank _prevscr _shelf
	integer _i _j _scr _currank=1 _prevscr
	typeset -a _shelf

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		_scr=${arr[_i]%\ *}
		if (( _i>0 )) && (( _scr != _prevscr )); then
			for ((_j=0; _j<${#_shelf[*]}; _j++)); do
				_ranked+=( "${_currank} ${_shelf[_j]}" )
			done
			(( _currank+=${#_shelf[*]} ))
			unset _shelf ; typeset -a _shelf
		fi
		_shelf+=( "${arr[_i]}" )
		_prevscr=${_scr}
	done
	for ((_j=0; _j<${#_shelf[*]}; _j++)); do
		_ranked+=( "${_currank} ${_shelf[_j]}" )
	done
}

#	# Function _rankModified(arr, rankarr) - retun arr with modified ranking
#
function _rankModified {
	typeset _ranked ; nameref _ranked="$1"

	typeset _i _j _scr _currank _prevscr _shelf
	integer _i _j _scr _currank=0 _prevscr
	typeset -a _shelf

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		_scr=${arr[_i]%\ *}
		if (( _i>0 )) && (( _scr != _prevscr )); then
			for ((_j=0; _j<${#_shelf[*]}; _j++)); do
				_ranked+=( "${_currank} ${_shelf[_j]}" )
			done
			unset _shelf ; typeset -a _shelf
		fi
		_shelf+=( "${arr[_i]}" )
		(( _currank++ ))
		_prevscr=${_scr}
	done
	for ((_j=0; _j<${#_shelf[*]}; _j++)); do
		_ranked+=( "${_currank} ${_shelf[_j]}" )
	done
}

#	# Function _rankDense(arr, rankarr) - retun arr with dense ranking
#
function _rankDense {
	typeset _ranked ; nameref _ranked="$1"

	typeset _i _j _scr _currank _prevscr _shelf
	integer _i _j _scr _currank=0 _prevscr
	typeset -a _shelf

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		_scr=${arr[_i]%\ *}
		if (( _i>0 )) && (( _scr != _prevscr )); then
			(( _currank++ ))
			for ((_j=0; _j<${#_shelf[*]}; _j++)); do
				_ranked+=( "${_currank} ${_shelf[_j]}" )
			done
			unset _shelf ; typeset -a _shelf
		fi
		_shelf+=( "${arr[_i]}" )
		_prevscr=${_scr}
	done
	(( _currank++ ))
	for ((_j=0; _j<${#_shelf[*]}; _j++)); do
		_ranked+=( "${_currank} ${_shelf[_j]}" )
	done
}

#	# Function _rankOrdinal(arr, rankarr) - retun arr with ordinal ranking
#
function _rankOrdinal {
	typeset _ranked ; nameref _ranked="$1"
	typeset _i ; integer _i

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		_ranked+=( "$(( _i + 1 )) ${arr[_i]}" )
	done
}

#	# Function _rankFractional(arr, rankarr) - retun arr with Fractional ranking
#
function _rankFractional {
	typeset _ranked ; nameref _ranked="$1"

	typeset _i _j _scr _currank _prevscr _shelf
	integer _i _j _scr _prevscr
	typeset -F1 _currank=1.0
	typeset -a _shelf

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		_scr=${arr[_i]%\ *}
		if (( _i>0 )) && (( _scr != _prevscr )); then
			(( _currank/=${#_shelf[*]} ))
			for ((_j=0; _j<${#_shelf[*]}; _j++)); do
				_ranked+=( "${_currank} ${_shelf[_j]}" )
			done
			_currank=0.0
			unset _shelf ; typeset -a _shelf
		fi
		(( _i>0 )) && (( _currank+=_i + 1 ))
		_shelf+=( "${arr[_i]}" )
		_prevscr=${_scr}
	done
	for ((_j=0; _j<${#_shelf[*]}; _j++)); do
		(( _currank/=${#_shelf[*]} ))
		_ranked+=( "${_currank} ${_shelf[_j]}" )
	done
}

 ######
# main #
 ######

printf "\n\nInput Data: ${#arr[*]} records\n---------------------\n"
for ((i=0; i< ${#arr[*]}; i++)); do
	print ${arr[i]}
done

typeset -a rankedarr
_rankStandard rankedarr
printf "\n\nStandard Ranking\n----------------\n"
for ((i=0; i< ${#rankedarr[*]}; i++)); do
	print ${rankedarr[i]}
done

unset rankedarr ; typeset -a rankedarr
_rankModified rankedarr
printf "\n\nModified Ranking\n----------------\n"
for ((i=0; i< ${#rankedarr[*]}; i++)); do
	print ${rankedarr[i]}
done

unset rankedarr ; typeset -a rankedarr
_rankDense rankedarr
printf "\n\nDense Ranking\n-------------\n"
for ((i=0; i< ${#rankedarr[*]}; i++)); do
	print ${rankedarr[i]}
done

unset rankedarr ; typeset -a rankedarr
_rankOrdinal rankedarr
printf "\n\nOrdinal Ranking\n---------------\n"
for ((i=0; i< ${#rankedarr[*]}; i++)); do
	print ${rankedarr[i]}
done

unset rankedarr ; typeset -a rankedarr
_rankFractional rankedarr
printf "\n\nFractional Ranking\n------------------\n"
for ((i=0; i< ${#rankedarr[*]}; i++)); do
	print ${rankedarr[i]}
done
