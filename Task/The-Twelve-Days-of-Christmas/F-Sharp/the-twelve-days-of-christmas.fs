let gifts = [
    "And a partridge in a pear tree";
    "Two turtle doves";
    "Three french hens";
    "Four calling birds";
    "FIVE GOLDEN RINGS";
    "Six geese a-laying";
    "Seven swans a-swimming";
    "Eight maids a-milking";
    "Nine ladies dancing";
    "Ten lords a-leaping";
    "Eleven pipers piping";
    "Twelve drummers drumming"
]

let days = [
    "first"; "second"; "third"; "fourth"; "fifth"; "sixth"; "seventh"; "eighth";
    "ninth"; "tenth"; "eleventh"; "twelfth"
]

let displayGifts day =
    printfn "On the %s day of Christmas, my true love gave to me" days.[day]
    if day = 0 then
        printfn "A partridge in a pear tree"
    else
        List.iter (fun i -> printfn "%s" gifts.[i]) [day..(-1)..0]
    printf "\n"

List.iter displayGifts [0..11]
