# Set doors to empty list
set doors

# Initialize doors arrays
for i in (seq 100)
    set doors[$i] 0
end

for i in (seq 100)
    set j $i
    while test $j -le 100
        # Logical not on doors
        set doors[$j] (math !$doors[$j])
        set j (math $j + $i)
    end
end

# Print every door
for i in (seq (count $doors))
    echo -n "$i "
    if test $doors[$i] -eq 0
        echo closed
    else
        echo open
    end
end
