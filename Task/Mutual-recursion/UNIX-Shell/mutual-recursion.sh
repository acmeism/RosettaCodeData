M()
{
    local n
    n=$1
    if [[ $n -eq 0 ]]; then
	echo -n 0
    else
	echo -n $(( n - $(F $(M $((n-1)) ) ) ))
    fi
}

F()
{
    local n
    n=$1
    if [[ $n -eq 0 ]]; then
	echo -n 1
    else
	echo -n $(( n - $(M $(F $((n-1)) ) ) ))
    fi
}

for((i=0; i < 20; i++)); do
    F $i
    echo -n " "
done
echo
for((i=0; i < 20; i++)); do
    M $i
    echo -n " "
done
echo
