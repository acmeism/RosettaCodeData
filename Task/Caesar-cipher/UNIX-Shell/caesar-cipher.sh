caesar() {
    local OPTIND
    local encrypt n=0
    while getopts :edn: option; do
        case $option in
            e) encrypt=true ;;
            d) encrypt=false ;;
            n) n=$OPTARG ;;
            :) echo "error: missing argument for -$OPTARG" >&2
               return 1 ;;
            ?) echo "error: unknown option -$OPTARG" >&2
               return 1 ;;
        esac
    done
    shift $((OPTIND-1))
    if [[ -z $encrypt ]]; then
        echo "error: specify one of -e or -d" >&2
        return 1
    fi

    local upper=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    local lower=abcdefghijklmnopqrstuvwxyz
    if $encrypt; then
        tr "$upper$lower" "${upper:n}${upper:0:n}${lower:n}${lower:0:n}" <<< "$1"
    else
        tr "${upper:n}${upper:0:n}${lower:n}${lower:0:n}" "$upper$lower" <<< "$1"
    fi
}

tr() {
    local -A charmap
    local i trans line char
    for ((i=0; i<${#1}; i++)); do
        charmap[${1:i:1}]=${2:i:1}
    done
    while IFS= read -r line; do
        trans=""
        for ((i=0; i<${#line}; i++)); do
            char=${line:i:1}
            if [[ -n ${charmap[$char]} ]]; then
                trans+=${charmap[$char]}
            else
                trans+=$char
            fi
        done
        echo "$trans"
    done
}

txt="The five boxing wizards jump quickly."
enc=$(caesar -e -n 5 "$txt")
dec=$(caesar -d -n 5 "$enc")

echo "original:  $txt"
echo "encrypted: $enc"
echo "decrypted: $dec"
