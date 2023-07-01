declare -A base36=(
    [A]=10 [B]=11 [C]=12 [D]=13 [E]=14 [F]=15 [G]=16 [H]=17 [I]=18
    [J]=19 [K]=20 [L]=21 [M]=22 [N]=23 [O]=24 [P]=25 [Q]=26 [R]=27
    [S]=28 [T]=29 [U]=30 [V]=31 [W]=32 [X]=33 [Y]=34 [Z]=35
)

function is_iban {
    local -u acct=${1//[^[:alnum:]]/}
    acct=${acct:4}${acct:0:4}
    local i char digits=""
    for ((i=0; i<${#acct}; i++)); do
        char=${acct:i:1}
        digits+=${base36[$char]:-$char}
    done
    local mod=$(mod97 $digits)
    (( mod == 1 ))
}

function mod97 {
    local D=$1
    N=${D:0:9}
    D=${D:9}
    while [[ -n $D ]]; do
        mod=$(( N % 97 ))
        N=$(printf "%02d%s" $mod ${D:0:7})
        D=${D:7}
    done
    echo $(( N % 97 ))
}

for test in "GB82 WEST 1234 5698 7654 32" "GB42 WEST 1234 5698 7654 32"; do
    printf "%s : " "$test"
    is_iban "$test" && echo yes || echo no
done
