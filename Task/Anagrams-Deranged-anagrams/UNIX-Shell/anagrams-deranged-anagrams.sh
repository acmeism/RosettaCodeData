function get_words {
    typeset host=www.puzzlers.org
    typeset page=/pub/wordlists/unixdict.txt
    exec 7<>/dev/tcp/$host/80
    print -e -u7 "GET $page HTTP/1.1\r\nhost: $host\r\nConnection: close\r\n\r\n"
    # remove the http header and save the word list
    sed 's/\r$//; 1,/^$/d' <&7 >"$1"
    exec 7<&-
}

function is_deranged {
    typeset -i i
    for ((i=0; i<${#1}; i++)); do
        [[ ${1:i:1} == ${2:i:1} ]] && return 1
    done
    return 0
}

function word2key {
    typeset -a chars=( $(
        for ((i=0; i<${#word}; i++)); do
            echo "${word:i:1}"
        done | sort
    ) )
    typeset IFS=""
    echo "${chars[*]}"
}

[[ -f word.list ]] || get_words word.list

typeset -A words
typeset -i max=0

while IFS= read -r word; do
    key=$(word2key $word)
    if [[ -z "${words["$key"]}" ]]; then
        words["$key"]=$word
    else
        if (( ${#word} > max )); then
            if is_deranged "${words["$key"]}" "$word"; then
                max_deranged=("${words["$key"]}" "$word")
                max=${#word}
            fi
        fi
    fi
done <word.list
echo $max - ${max_deranged[@]}
