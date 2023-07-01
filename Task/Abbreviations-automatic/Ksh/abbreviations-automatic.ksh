#!/bin/ksh

# Abbreviations, automatic

#	# Variables:
#
dow_file='../dow'

typeset -T Dow_T=(
	typeset -a -h	"Week day name array"			dow
	typeset -si -h	"minimum length abbreviation"	minabv

	function init_dow {
		_.minabv=$1
		_.dow=( $2 )
	}

	function print_wk {
		typeset i ; typeset -si i

		printf "(%d)  " ${_.minabv}
		for((i=0; i<${#_.dow[*]}; i++)); do
			printf "%${_.minabv}s " ${_.dow[i]:0:${_.minabv}}
		done
		printf "\n"
	}
)

#	# Functions:
#
#	# Function _file2arr(fn, arr) - read file fn into arr
#
function _file2arr {
	typeset _fn ; _fn="$1"
	typeset _arr ; nameref _arr="$2"
	typeset _i ; typeset -si _i=0

	while read; do
		_arr[_i++]="$REPLY"
	done < ${_fn}

}

#	# Function _minabbr(buff) - return the min length abbr for items in buff
#
function _minabbr {
	typeset _buf ; _buf="$1"
	typeset _i _flg ; typeset -si _i=0 _cnt
	typeset _item _list _abr

	until (( _cnt == 7 )); do
		unset _list
		_cnt=0
		(( _i++ ))
		for _item in ${_buf}; do
			_abr=${_item:0:${_i}}
			[[ ${_abr} == @(${_list}) ]] && break
			_list+="${_abr}|"
			(( _cnt++ ))
		done
	done

	echo ${_i}
}

 ######
# main #
 ######

typeset -a dow langs
_file2arr "${dow_file}" dow

for ((i=0; i<${#dow[*]}; i++)); do
	(( ! ${#dow[i]} )) && { print "Blank Input, line $((i+1))" ; continue ;}
	alen=$(_minabbr "${dow[i]}")
	Dow_T langs[i]
	langs[i].init_dow ${alen} "${dow[i]}"
	
	(( $((RANDOM%100+1))<=5 )) && { printf "%d. " $((i+1)) ; langs[i].print_wk ;}
done
