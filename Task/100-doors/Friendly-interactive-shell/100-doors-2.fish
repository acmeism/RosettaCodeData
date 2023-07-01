# Set doors to empty list
set doors

for i in (seq 100)
    set doors[(math "$i * $i")] 1
    echo -n "$i "
    if test $doors[$i] -eq 1
        echo open
    else
        echo closed
    end
end
