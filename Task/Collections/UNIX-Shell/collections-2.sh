declare -A a_assoc=([one]=1 [two]=2 [three]=3)    # create an array with a few elements
a_assoc+=([four]=4 [five]=5)                      # add some elements
a_assoc[ten]=10
for value in "${a_assoc[@]}"; do                  # interate over the values
    echo "$value"
done
for key in "${!a_assoc[@]}"; do                   # interate over the array indices
    printf "%s\t%s\n" "$key" "${a_assoc[$key]}"
done
