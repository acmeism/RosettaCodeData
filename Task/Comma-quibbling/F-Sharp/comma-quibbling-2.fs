> quibble [];;
val it : string = "{}"
> quibble ["ABC"];;
val it : string = "{ABC}"
> quibble ["ABC"; "DEF"];;
val it : string = "{ABC and DEF}"
> quibble ["ABC"; "DEF"; "G"];;
val it : string = "{ABC, DEF and G}"
> quibble ["ABC"; "DEF"; "G"; "H"];;
val it : string = "{ABC, DEF, G and H}"
