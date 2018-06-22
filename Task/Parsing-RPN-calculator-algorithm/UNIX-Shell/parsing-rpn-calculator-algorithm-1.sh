#!/bin/sh

exp() {
    R=1
    local i=1

    while [ $i -le $2 ]; do
        R=$(($R * $1))
        i=$(($i + 1))
    done
}

rpn() {
    local O1 O2 stack

    while [ $# -ge 1 ]; do
        grep -iE '^-?[0-9]+$' <<< "$1" > /dev/null 2>&1
        if [ "$?" -eq 0 ]; then
            stack=`sed -e '$a'"$1" -e '/^$/d' <<< "$stack"`
        else
            grep -iE '^[-\+\*\/\%\^]$' <<< "$1" > /dev/null 2>&1
            if [ "$?" -eq 0 ]; then
                O2=`sed -n '$p' <<< "$stack"`
                stack=`sed '$d' <<< "$stack"`
                O1=`sed -n '$p' <<< "$stack"`

                case "$1" in
                    '+')
                        stack=`sed -e '$a'"$(($O1 + $O2))" -e '/^$/d' -e '$d' \
                            <<< "$stack"`;;
                    '-')
                        stack=`sed -e '$a'"$(($O1 - $O2))" -e '/^$/d' -e '$d' \
                            <<< "$stack"`;;
                    '*')
                        stack=`sed -e '$a'"$(($O1 * $O2))" -e '/^$/d' -e '$d' \
                            <<< "$stack"`;;
                    '/')
                        stack=`sed -e '$a'"$(($O1 / $O2))" -e '/^$/d' -e '$d' \
                            <<< "$stack"`;;
                    '%')
                        stack=`sed -e '$a'"$(($O1 % $O2))" -e '/^$/d' -e '$d' \
                            <<< "$stack"`;;
                    '^')
                        exp $O1 $O2
                        stack=`sed -e '$a'"$(($R))" -e '/^$/d' -e '$d' <<< \
                            "$stack"`;;
                esac
            else
                echo "Unknown RPN token \`\`$1''"
            fi
        fi
        echo "$1" ":" $stack
        shift
    done

    sed -n '1p' <<< "$stack"
    if [ "`wc -l <<< "$stack"`" -gt 1 ]; then
        echo "Malformed input expression" > /dev/stderr
        return 1
    else
        return 0
    fi
}

rpn 3 4 2 '*' 1 5 '-' 2 3 '^' '^' '/' '+'
