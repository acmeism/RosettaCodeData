#!/bin/ksh

# Perform XPath queries on a XML Document

#	# Variables:
#
typeset -T Xml_t=(
	typeset -h		'UPC'			upc
	typeset -i -h	'num in stock'	stock=0
	typeset -h		'name'			name
	typeset -F2 -h	'price'			price
	typeset -h		'description'	description

	function init_item {
		typeset key ; key="$1"
		typeset val ; val="${2%\<\/${key}*}"

		case ${key} in
			upc)			_.upc="${val//@(\D)/}"
				;;
			stock)			_.stock="${val//@(\D)/}"
				;;
			name)			_.name="${val%\<\/${key}*}"
				;;
			price)			_.price="${val}"
				;;
			description)	_.description=$(echo ${val})
				;;
		esac
	}

	function prt_item {
		print "upc= ${_.upc}"
		print "stock= ${_.stock}"
		print "name= ${_.name}"
		print "price= ${_.price}"
		print "description= ${_.description}"
	}
)

#	# Functions:
#


 ######
# main #
 ######
integer i=0
typeset -a Item_t

buff=$(< xmldoc)	# read xmldoc
item=${buff%%'</item>'*} ; buff=${.sh.match}

while [[ -n ${item} ]]; do
	Xml_t Item_t[i]
	item=${item#*'<item'} ; item=$(echo ${item})
	for word in ${item}; do
		if [[ ${word} == *=* ]]; then
			Item_t[i].init_item ${word%\=*} ${word#*\=}
		else
			if [[ ${word} == \<* ]]; then		# Beginning
				key=${word%%\>*} ; key=${key#*\<}
				val=${word#*\>}
			fi

			[[ ${word} != \<* && ${word} != *\> ]] && val+=" ${word} "

			if [[ ${word} == *\> ]]; then		# End
				val+=" ${word%\<${key}\>*}"
				Item_t[i].init_item "${key}" "${val}"
			fi
		fi
	done
	(( i++ ))
	item=${buff#*'</item>'} ; item=${item%%'</item>'*} ; buff=${.sh.match}
done

print "First Item element:"
Item_t[0].prt_item

typeset -a names
printf "\nList of prices:\n"
for ((i=0; i<${#Item_t[*]}-1; i++)); do
	print ${Item_t[i].price}
	names[i]=${Item_t[i].name}
done

printf "\nArray of names:\n"
for (( i=0; i<${#names[*]}; i++)); do
	print "names[$i] = ${names[i]}"
done
