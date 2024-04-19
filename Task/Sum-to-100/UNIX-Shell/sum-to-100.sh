sumto100() {
    typeset expr sum max_count=0 max_values i
    typeset -A histogram
    printf 'Strings that evaluate to 100:\n'
    for expr in {,-}1{,+,-}2{,+,-}3{,+,-}4{,+,-}5{,+,-}6{,+,-}7{,+,-}8{,+,-}9
    do
       (( sum = expr ))
        if (( sum == 100 )); then
           printf '\t%s\n' "$expr"
        fi
        histogram[$sum]=$(( ${histogram[$sum]:-0}+1 ))
        if (( histogram[$sum] > max_count )); then
            (( max_count = histogram[$sum] ))
            max_values=( $sum )
        elif (( histogram[$sum] == max_count )); then
            max_values+=( $sum )
        fi
    done
    printf '\nMost solutions for any number is %d: ' "$max_count"
    if [[ -n $ZSH_VERSION ]]; then
        printf '%s\n\n' "${(j:, :)max_values}"
    else
        printf '%s' "${max_values[0]}"
        printf ', %s' "${max_values[@]:1}"
        printf '\n\n'
    fi

    for (( i=1; i<123456789; ++i )); do
        if (( !histogram[$i] )); then
           printf "Lowest positive sum that can't be expressed: %d\n\n" "$i"
           break
        fi
    done
    printf 'Ten highest reachable numbers:\n';
    if [[ -n $ZSH_VERSION ]]; then
         printf '\t%9d\n' "${(k@)histogram}"
    else
         printf '\t%9d\n' "${!histogram[@]}"
    fi | sort -nr | head -n 10
}

sumto100
