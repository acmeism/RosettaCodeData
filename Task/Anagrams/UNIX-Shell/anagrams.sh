http_get_body() {
    local host=$1
    local uri=$2
    exec 5<> /dev/tcp/$host/80
    printf >&5 "%s\r\n" "GET $uri HTTP/1.1" "Host: $host" "Connection: close" ""
    mapfile -t -u5
    local lines=( "${MAPFILE[@]//$'\r'}" )
    local i=0 found=0
    for (( ; found == 0; i++ )); do
        [[ -z ${lines[i]} ]] && (( found++ ))
    done
    printf "%s\n" "${lines[@]:i}"
    exec 5>&-
}

declare -A wordlist

while read -r word; do
    uniq_letters=( $(for ((i=0; i<${#word}; i++)); do echo "${word:i:1}"; done | sort) )
    wordlist["${uniq_letters[*]}"]+="$word "
done < <( http_get_body www.puzzlers.org  /pub/wordlists/unixdict.txt )

maxlen=0
maxwords=()

for key in "${!wordlist[@]}"; do
    words=( ${wordlist[$key]} )
    if (( ${#words[@]} > maxlen )); then
        maxlen=${#words[@]}
        maxwords=( "${wordlist["$key"]}" )
    elif (( ${#words[@]} == maxlen )); then
        maxwords+=( "${wordlist[$key]}" )
    fi
done

printf "%s\n" "${maxwords[@]}"
