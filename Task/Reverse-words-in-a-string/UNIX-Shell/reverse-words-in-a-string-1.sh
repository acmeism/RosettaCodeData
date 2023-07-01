while read -a words; do
    for ((i=${#words[@]}-1; i>=0; i--)); do
        printf "%s " "${words[i]}"
    done
    echo
done << END
---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------
END
