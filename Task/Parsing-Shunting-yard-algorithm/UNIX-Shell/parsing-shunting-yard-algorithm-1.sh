#!/bin/sh

getopprec() {
    case "$1" in
        '+') echo 2;;
        '-') echo 2;;
        '*') echo 3;;
        '/') echo 4;;
        '%') echo 4;;
        '^') echo 4;;
        '(') echo 5;;
    esac
}

getopassoc() {
    case "$1" in
        '^') echo r;;
        *)   echo l;;
    esac
}

showstacks() {
    [ -n "$1" ] && echo "Token: $1" || echo "End parsing"
    echo -e "\tOutput: `tr $'\n' ' ' <<< "$out"`"
    echo -e "\tOperators: `tr $'\n' ' ' <<< "$ops"`"
}

infix() {
    local out="" ops=""

    while [ "$#" -gt 0 ]; do
        grep -qE '^[0-9]+$' <<< "$1"
        if [ "$?" -eq 0 ]; then
            out="`sed -e '$a'"$1" -e '/^$/d' <<< "$out"`"

            showstacks "$1"
            shift && continue
        fi

        grep -q '^[-+*/^%]$' <<< "$1"
        if [ "$?" -eq 0 ]; then
            if [ -n "$ops" ]; then
                thispred=`getopprec "$1"`
                thisassoc=`getopassoc "$1"`
                topop="`sed -n '$p' <<< "$ops"`"
                thatpred=`getopprec "$topop"`
                thatassoc=`getopassoc "$topop"`
                while [ $thatpred -gt $thispred ] 2> /dev/null || ( [ \
                    $thatpred -eq $thispred ] 2> /dev/null && [ $thisassoc = \
                    'l' ] 2> /dev/null ); do # To /dev/null 'cus u r fake news

                    [ "$topop" = '(' ] && break

                    op="`sed -n '$p' <<< "$ops"`"
                    out="`sed -e '$a'"$op" -e '/^$/d' <<< "$out"`"
                    ops="`sed '$d' <<< "$ops"`"

                    topop="`sed -n '$p' <<< "$ops"`"
                    thatpred=`getopprec "$topop"`
                    thatassoc=`getopassoc "$topop"`
                done
            fi
            ops="`sed -e '$a'"$1" -e '/^$/d' <<< "$ops"`"

            showstacks "$1"
            shift && continue
        fi

        if [ "$1" = '(' ]; then
            ops="`sed -e '$a'"$1" -e '/^$/d' <<< "$ops"`"

            showstacks "$1"
            shift && continue
        fi

        if [ "$1" = ')' ]; then
            grep -q '^($' <<< "`sed -n '$p' <<< "$ops"`"
            while [ "$?" -ne 0 ]; do
                op="`sed -n '$p' <<< "$ops"`"
                out="`sed -e '$a'"$op" -e '/^$/d' <<< "$out"`"
                ops="`sed '$d' <<< "$ops"`"

                grep -q '^($' <<< "`sed '$p' <<< "$ops"`"
            done
            ops="`sed '$d' <<< "$ops"`"

            showstacks "$1"
            shift && continue
        fi

        shift
    done

    while [ -n "$ops" ]; do
        op="`sed -n '$p' <<< "$ops"`"
        out="`sed -e '$a'"$op" -e '/^$/d' <<< "$out"`"
        ops="`sed '$d' <<< "$ops"`"
    done

    showstacks "$1"
}

infix 3 + 4 \* 2 / \( 1 - 5 \) ^ 2 ^ 3
