function urlencode
{
	typeset decoded=$1 encoded= rest= c=
	typeset rest2= bug='rest2=${rest}'

	if [[ -z ${BASH_VERSION} ]]; then
		# bug /usr/bin/sh HP-UX 11.00
		typeset _decoded='xyz%26xyz'
		rest="${_decoded#?}"
		c="${_decoded%%${rest}}"
		if (( ${#c} != 1 )); then
			typeset qm='????????????????????????????????????????????????????????????????????????'
			typeset bug='(( ${#rest} > 0 )) && typeset -L${#rest} rest2="${qm}" || rest2=${rest}'
		fi
	fi

	rest="${decoded#?}"
	eval ${bug}
	c="${decoded%%${rest2}}"
	decoded="${rest}"

	while [[ -n ${c} ]]; do
		case ${c} in
		[-a-zA-z0-9.])
			;;
		' ')
			c='+'
			;;
		*)
			c=$(printf "%%%02X" "'$c")
			;;
		esac

		encoded="${encoded}${c}"

		rest="${decoded#?}"
		eval ${bug}
		c="${decoded%%${rest2}}"
		decoded="${rest}"
	done

	if [[ -n ${BASH_VERSION:-} ]]; then
		\echo -E "${encoded}"
	else
		print -r -- "${encoded}"
	fi
}
