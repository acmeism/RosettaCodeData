check_isbn13 () {
    local i n t
    n=${1//[^0-9]/}
    t=0
    for ((i=0; i<${#n}; ++i )); do
      (( t += ${n:i:1}*(1 + ((i&1)<<1)) ))
    done
    (( 0 == t % 10 ))
}

for isbn in 978-0596528126 978-0596528120 978-1788399081 978-1788399083; do
  printf '%s: ' "$isbn"
  if check_isbn13 "$isbn"; then
    printf '%s\n' OK
  else
    printf '%s\n' 'NOT OK'
  fi
done
