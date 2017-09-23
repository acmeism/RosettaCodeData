function entropy
    for arg in $argv
        set name count_$arg
        if not count $$name > /dev/null
            set $name 0
            set values $values $arg
        end
        set $name (math $$name + 1)
    end
    set entropy 0
    for value in $values
        set name count_$value
        set entropy (echo "
            scale = 50
            p = "$$name" / "(count $argv)"
            $entropy - p * l(p)
        " | bc -l)
    end
    echo "$entropy / l(2)" | bc -l
end
entropy (echo 1223334444 | fold -w1)
