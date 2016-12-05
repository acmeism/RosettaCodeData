soundex() {
    local -u word=${1//[^[:alpha:]]/.}
    local letter=${word:0:1}
    local soundex=$letter
    local previous=$letter

    word=${word:1}
    word=${word//[AEIOUY]/.}
    word=${word//[WH]/=}

    while [[ ${#soundex} -lt 4 && -n $word ]]; do
        letter=${word:0:1}

        if [[ $letter == "." ]]; then
            previous=""

        elif [[ $letter == "=" ]]; then
            if [[ $previous == [A-Z] && ${word:1:1} == [A-Z] ]] &&
               [[ ${value[$previous]} -eq ${value[${word:1:1}]} ]]
            then
                word=${word:1}
            fi

        elif [[ -z $previous ]] ||
             [[ $letter != $previous && ${value[$letter]} -ne ${value[$previous]} ]]
        then
            previous=$letter
            soundex+=${value[$letter]}
        fi

        word=${word:1}
    done
    # right pad with zeros
    soundex+="000"
    echo "${soundex:0:4}"
}
