a_index=(one two three)           # create an array with a few elements
a_index+=(four five)              # append some elements
a_index[9]=ten                   # add a specific index
for elem in "${a_index[@]}"; do   # interate over the elements
    echo "$elem"
done
for idx in "${!a_index[@]}"; do   # interate over the array indices
    printf "%d\t%s\n" $idx "${a_index[idx]}"
done
