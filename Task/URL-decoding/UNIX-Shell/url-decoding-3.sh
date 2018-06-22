function urldecode
{
        typeset encoded=$1 decoded= rest= c= c1= c2=
        typeset rest2= bug='rest2=${rest}'

        if [[ -z ${BASH_VERSION:-} ]]; then
                typeset -i16 hex=0; typeset -i8 oct=0

                # bug /usr/bin/sh HP-UX 11.00
                typeset _encoded='xyz%26xyz'
                rest="${_encoded#?}"
                c="${_encoded%%${rest}}"
                if (( ${#c} != 1 )); then
                        typeset qm='????????????????????????????????????????????????????????????????????????'
                        typeset bug='(( ${#rest} > 0 )) && typeset -L${#rest} rest2="${qm}" || rest2=${rest}'
                fi
        fi

	rest="${encoded#?}"
	eval ${bug}
	c="${encoded%%${rest2}}"
	encoded="${rest}"

	while [[ -n ${c} ]]; do
		if [[ ${c} = '%' ]]; then
			rest="${encoded#?}"
			eval ${bug}
			c1="${encoded%%${rest2}}"
			encoded="${rest}"

			rest="${encoded#?}"
			eval ${bug}
			c2="${encoded%%${rest2}}"
			encoded="${rest}"

			if [[ -z ${c1} || -z ${c2} ]]; then
				c="%${c1}${c2}"
				echo "WARNING: invalid % encoding: ${c}" >&2
			elif [[ -n ${BASH_VERSION:-} ]]; then
				c="\\x${c1}${c2}"
				c=$(\echo -e "${c}")
			else
				hex="16#${c1}${c2}"; oct=hex
				c="\\0${oct#8\#}"
				c=$(print -- "${c}")
			fi
		elif [[ ${c} = '+' ]]; then
			c=' '
		fi

		decoded="${decoded}${c}"

		rest="${encoded#?}"
		eval ${bug}
		c="${encoded%%${rest2}}"
		encoded="${rest}"
	done

	if [[ -n ${BASH_VERSION:-} ]]; then
		\echo -E "${decoded}"
	else
		print -r -- "${decoded}"
	fi
}
