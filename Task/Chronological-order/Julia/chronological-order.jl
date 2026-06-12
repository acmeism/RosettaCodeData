const TABLE = """
Pi                250  BCE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE

"""

const TABLE2 = """
Pi             250  BCE
Magic Squares  2200 BCE
Kwarizmi       830  CE
Dice           3000 BCE
Liber Abaci    1202 CE
Euler's Number 1727 CE
The Abacus     1200 CE

"""

function bcebcsortkey(line)
    parts = split(strip(line), r"\s+", keepempty = false)
    year = parse(Int, parts[end-1])
    return startswith(parts[end], "BC") ? -year : year
end

function sorttable(table)
    lines = split(table, '\n', keepempty = false)
    return join(sort!(lines, by = bcebcsortkey), '\n')
end

println("Sorted Table 1:\n", sorttable(TABLE))
println("\nSorted Table 2:\n", sorttable(TABLE2))
