function luhn {
  typeset n p s t=('0123456789' '0516273849')
  while ((-n<${#1})); do
    p="${t[n--%2]%${1:n:1}*}"
    ((s+=${#p}))
  done
  ((s%10))
}

for c in 49927398716 49927398717 1234567812345678 1234567812345670; do
    if luhn $c; then
        echo $c is invalid
    else
        echo $c is valid
    fi
done
