generate() {
    local b=()
    local i j tmp
    for ((i=1; i<=$1; i++)); do
        b+=( '[' ']')
    done
    for ((i=${#b[@]}-1; i>0; i--)); do
        j=$(rand $i)
        tmp=${b[j]}
        b[j]=${b[i]}
        b[i]=$tmp
    done
    local IFS=
    echo "${b[*]}"
}

# a random number in the range [0,n)
rand() {
    echo $(( $RANDOM % $1 ))
}

balanced() {
    local -i lvl=0
    local i
    for ((i=0; i<${#1}; i++)); do
        case ${1:i:1} in
            '[') ((lvl++));;
            ']') (( --lvl < 0 )) && return 1;;
        esac
    done
    (( lvl == 0 )); return $?
}

for ((i=0; i<=10; i++)); do
    test=$(generate $i)
    balanced "$test" && result=OK || result="NOT OK"
    printf "%s\t%s\n" "$test" "$result"
done
