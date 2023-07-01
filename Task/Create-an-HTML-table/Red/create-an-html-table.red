Create an HTML table

The table body should have at least three rows of three columns.
Each of these three columns should be labelled "X", "Y", and "Z".
An extra column should be added at either the extreme left or the extreme right
of the table that has no heading, but is filled with sequential row numbers.
The rows of the "X", "Y", and "Z" columns should be filled with random or
sequential integers having 4 digits or less.
The numbers should be aligned in the same fashion for all columns.

Red [
    Problem: %http://www.rosettacode.org/wiki/Create_an_HTML_table
    Code: %https://github.com/metaperl/red-rosetta/blob/master/html-table.r
    Acknowledgements: "@endo64 @toomsav"
]

result: func[][simple-tag "table" trs]

trs: func [][rejoin [
        first-tr
        rand-tr 1
        rand-tr 2
        rand-tr 3
        rand-tr 4
        rand-tr 5
    ]]

table-data: func [][999 + (random 9000)]
rand-td: func [][simple-tag "td" table-data]
rand-tr: func [i][rejoin [
        simple-tag "tr"
            rejoin [(simple-tag "td" i) rand-td rand-td rand-td]
    ]]
first-tr: func[][rejoin [
        simple-tag "tr" rejoin [
            simple-tag "th" ""
            simple-tag "th" "X"
            simple-tag "th" "Y"
            simple-tag "th" "Z"
            ]
    ]]

simple-tag: func [tag contents /attr a][rejoin
    ["<" tag (either attr [rejoin [" " a/1 "=" {"} a/2 {"}]][]) ">"
        newline contents newline "</" tag ">"]]
