can_build_word() {
    if [[ $1 ]]; then
        can_build_word_rec "$1" BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM
    else
        return 1
    fi
}

can_build_word_rec() {
    [[ -z $1 ]] && return 0

    local -u word=$1       # uppercase the first parameter
    shift
    local blocks=("$@")

    # see if we have a block for the first letter
    local letter=${word:0:1} indices=() i
    for (( i=0; i<${#blocks[@]}; i++ )); do
        if [[ ${blocks[i]} == *$letter* ]]; then
            indices+=($i)
        fi
    done
    (( ${#indices[@]} == 0 )) && return 1

    local tmp
    for i in ${indices[@]}; do
        tmp=( "${blocks[@]}" )
        unset "tmp[$i]"
        can_build_word_rec "${word:1}" "${tmp[@]}" && return 0
    done

    return 1
}

words=( "" A BARK Book treat COMMON Squad confuse )
for word in "${words[@]}"; do
    can_build_word "$word" "${blocks[@]}" && ans=yes || ans=no
    printf "%s\t%s\n" "$word" $ans
done
