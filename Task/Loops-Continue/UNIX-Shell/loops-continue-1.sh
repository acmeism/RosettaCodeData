Z=1
while (( Z<=10 )); do
    echo -e "$Z\c"
    if (( Z % 5 != 0 )); then
        echo -e ", \c"
    else
        echo -e ""
    fi
    (( Z++ ))
done
