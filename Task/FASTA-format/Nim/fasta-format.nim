import strutils

let input = """>Rosetta_Example_1
    THERECANBENOSPACE
    >Rosetta_Example_2
    THERECANBESEVERAL
    LINESBUTTHEYALLMUST
    BECONCATENATED""".unindent

proc fasta*(input: string) =
    var row = ""
    for line in input.splitLines:
        if line.startsWith(">"):
            if row != "": echo row
            row = line[1..^1] & ": "
        else:
            row &= line.strip
    echo row

fasta(input)
