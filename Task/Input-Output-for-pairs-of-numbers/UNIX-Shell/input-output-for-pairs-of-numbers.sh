read n
while (( n > 0 )); do
    read a b
    echo $((a+b))
    ((n--))
done
