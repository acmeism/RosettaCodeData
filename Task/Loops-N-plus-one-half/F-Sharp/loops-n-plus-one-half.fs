let rec print (lst : int list) =
    match lst with
    | hd :: [] ->
        printf "%i " hd
    | hd :: tl ->
        printf "%i, " hd
        print tl
    | [] -> printf "\n"

print [1..10]
