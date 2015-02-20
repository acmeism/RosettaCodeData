luhn() {
    reverse $1 | {
        while read odd; do
            (( s1 += odd ))
            read even
            e=0
            for digit in $(digits $(( 2 * even)) ); do
                (( e += digit ))
            done
            (( s2 += e ))
        done
        (( (s1+s2) % 10 == 0 ))
    }
}

reverse() {
    local i digits=( $(digits $1) )
    for ((i=${#digits[@]}-1; i>=0; i--)); do
        echo ${digits[i]}
    done
}

digits() {
    local i
    for ((i=0; i<${#1}; i++)); do
        echo ${1:i:1}
    done
}

for c in 49927398716 49927398717 1234567812345678 1234567812345670; do
    if luhn $c; then
        echo $c is valid
    else
        echo $c is invalid
    fi
done
