#!/bin/ksh

# Read a configuration file

#	# Variables:
#

#	# The configuration file (below) could be read in from a file
#	  But this method keeps everything together.
# e.g. config=$(< /path/to/config_file)

integer config_num=0
config='# This is a configuration file in standard configuration file format
#
# Lines beginning with a hash or a semicolon are ignored by the application
# program. Blank lines are also ignored by the application program.

# This is the fullname parameter
FULLNAME Foo Barber

# This is a favourite fruit
FAVOURITEFRUIT banana

# This is a boolean that should be set
NEEDSPEELING

# This boolean is commented out
; SEEDSREMOVED

# Configuration option names are not case sensitive, but configuration parameter
# data is case sensitive and may be preserved by the application program.

# An optional equals sign can be used to separate configuration parameter data
# from the option name. This is dropped by the parser.

# A configuration option may take multiple parameters separated by commas.
# Leading and trailing whitespace around parameter names and parameter data fields
# are ignored by the application program.

OTHERFAMILY Rhu Barber, Harry Barber'

isComment='#|;'
paraDelim=' |='
boolean="SEEDSREMOVED|NEEDSPEELING"

typeset -T Config_t=(
	typeset -h		'Full name'				fullname
	typeset -h		'Favorite fruit'		favouritefruit
	typeset -h		'Boolean NEEDSPEELING'	needspeeling=false
	typeset -h		'Boolean SEEDSREMOVED'	seedsremoved=false
	typeset -a -h	'Other family'			otherfamily

	function set_name {
		typeset fn ; fn=$(echo $1)	# Strip any leading/trailing white space
		_.fullname="${fn}"
	}

	function set_fruit {
		typeset fruit ; fruit=$(echo $1)
		_.favouritefruit="${fruit}"
	}

	function set_bool {
		typeset bool ; typeset -u bool=$1

		case ${bool} in
			NEEDSPEELING) _.needspeeling=true ;;
			SEEDSREMOVED) _.seedsremoved=true ;;
		esac
	}

	function set_family {
		typeset ofam ; ofam=$(echo $1)
		typeset farr i ; typeset -a farr ; integer i

		oldIFS="$IFS" ; IFS=',' ; farr=( ${ofam} ) ; IFS="${oldIFS}"
		for ((i=0; i<${#farr[*]}; i++)); do
			_.otherfamily[i]=$(echo ${farr[i]})
		done
	}
)

#	# Functions:
#

#	# Function _parseconf(config) - Parse uncommented lines
#
function _parseconf {
	typeset _cfg ; _cfg="$1"
	typeset _conf ; nameref _conf="$2"

	echo "${_cfg}" |	\
	while read; do
		[[ $REPLY == @(${isComment})* ]] || [[ $REPLY == '' ]] && continue
		_parseline "$REPLY" _conf
	done
}

function _parseline {
	typeset _line ; _line=$(echo $1)
	typeset _conf ; nameref _conf="$2"
	typeset _param _value ; typeset -u _param

	_param=${_line%%+(${paraDelim})*}
	_value=${_line#*+(${paraDelim})}

	if [[ ${_param} == @(${boolean}) ]]; then
		_conf.set_bool ${_param}
	else
		case ${_param} in
			FULLNAME)		_conf.set_name "${_value}" ;;
			FAVOURITEFRUIT)	_conf.set_fruit ${_value} ;;
			OTHERFAMILY)	_conf.set_family "${_value}" ;;
		esac
	fi
}
 ######
# main #
 ######

typeset -a configuration		# Indexed array of configurations
Config_t configuration[config_num]
_parseconf "${config}" configuration[config_num]

for cnum in ${!configuration[*]}; do
	printf "fullname = %s\n" "${configuration[cnum].fullname}"
	printf "favouritefruit = %s\n" ${configuration[cnum].favouritefruit}
	printf "needspeeling = %s\n" ${configuration[cnum].needspeeling}
	printf "seedsremoved = %s\n" ${configuration[cnum].seedsremoved}
	for ((i=0; i<${#configuration[cnum].otherfamily[*]}; i++)); do
		print "otherfamily($((i+1))) = ${configuration[cnum].otherfamily[i]}"
	done
done
