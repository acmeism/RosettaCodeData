for(( Z=1; Z<=10; Z++ )); do
    echo -e "$Z\c"
    if (( Z != 10 )); then
        echo -e ", \c"
    fi
done
