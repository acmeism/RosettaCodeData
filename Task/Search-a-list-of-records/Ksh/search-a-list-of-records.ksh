#!/bin/ksh

# Search a list of records

#	# Variables:
#
json='{ "name": "Lagos",                "population": 21.0  },
  { "name": "Cairo",                "population": 15.2  },
  { "name": "Kinshasa-Brazzaville", "population": 11.3  },
  { "name": "Greater Johannesburg", "population":  7.55 },
  { "name": "Mogadishu",            "population":  5.85 },
  { "name": "Khartoum-Omdurman",    "population":  4.98 },
  { "name": "Dar Es Salaam",        "population":  4.7  },
  { "name": "Alexandria",           "population":  4.58 },
  { "name": "Abidjan",              "population":  4.4  },
  { "name": "Casablanca",           "population":  3.98 }'

typeset -a African_Metro
integer i=0

typeset -T Metro_Africa_t=(
	typeset -h		'Metro name'		met_name=''
	typeset -E3 -h	'Metro population'	met_pop

	function init_metro {
		typeset name ; name="$1"
		typeset pop ; typeset -E3 pop=$2

		_.met_name=${name}
		_.met_pop=${pop}
	}

	function prt_name {
		print "${_.met_name}"
	}

	function prt_pop {
		print "${_.met_pop}"
	}
)

#	# Functions:
#

#	# Function _findcityindex(arr, name) - return array index of citry named "name"
#
function _findcityindex {
	typeset _arr ; nameref _arr="$1"
	typeset _name ; _name="$2"
	typeset _i ; integer _i

	for ((_i=0; _i<${#_arr[*]}; _i++)); do
		[[ ${_name} == $(_arr[_i].prt_name) ]] && echo ${_i} && return 0
	done
	
	echo "-1"
	return 1
}

#	# Function _findcitynamepop(arr, pop, xx) - find 1st city name pop $3 of $2
#
function _findcitynamepop {
	typeset _arr ; nameref _arr="$1"
	typeset _pop ; typeset -E3 _pop=$2
	typeset _comp ; _comp="$3"
	typeset _i ; integer _i

	for ((_i=0; _i<${#_arr[*]}; _i++)); do
		case ${_comp} in
		gt)
			[[ $(_arr[_i].prt_pop) -gt ${_pop} ]] && _arr[_i].prt_name && return 0 ;;
		lt)
			[[ $(_arr[_i].prt_pop) -lt ${_pop} ]] && _arr[_i].prt_name && return 0 ;;
		esac
	done
	
	echo "DNE"
	return 1
}

#	# Function _findcitypopname(arr, pat) - find pop of first city starting w/ pat
#
function _findcitypopname {
	typeset _arr ; nameref _arr="$1"
	typeset _pat ; _pat="$2"
	typeset _i ; integer _i

	for ((_i=0; _i<${#_arr[*]}; _i++)); do
		[[ $(_arr[_i].prt_name) == ${_pat}* ]] && _arr[_i].prt_pop && return 0
	done
	
	echo "-1"
	return 1
}

 ######
# main #
 ######

#	# An indexed array of Type variable (objects)
#
echo "${json}" | while read; do
	metro="${REPLY#*\"name\"\:\ }" ; metro="${metro%%\,*}" ;  metro="${metro//\"/}"
	population="${REPLY#*\"population\"\:\ }" ; population=${population%+(\ )\}*(\,)}

	Metro_Africa_t African_Metro[i]
	African_Metro[i++].init_metro "${metro}" ${population}
done

_findcityindex African_Metro "Dar Es Salaam"
_findcitynamepop African_Metro 5.0 lt
_findcitypopname African_Metro "A"
