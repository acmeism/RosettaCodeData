set aTable to "UK	London
US	New York
US	Birmingham
UK	Birmingham"

-- -s = stable sort; -t sets the field separator, -k sets the sort "column" range in field numbers.
set stableSortedOnColumn2 to (do shell script ("sort -st'" & tab & "' -k2,2 <<<" & quoted form of aTable))
set stableSortedOnColumn1 to (do shell script ("sort -st'" & tab & "' -k1,1 <<<" & quoted form of aTable))
return "Stable sorted on column 2:" & (linefeed & stableSortedOnColumn2) & (linefeed & linefeed & ¬
    "Stable sorted on column 1:") & (linefeed & stableSortedOnColumn1)
