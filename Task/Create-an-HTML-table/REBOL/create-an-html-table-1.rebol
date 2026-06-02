Rebol [
    title: "Rosetta code: Create an HTML table"
    file:  %Create_an_HTML_table.r3
    url:   https://rosettacode.org/wiki/Create_an_HTML_table
    note: "Based on Red language implementation!"
]
table-rows: func [][rejoin [
    first-tr  newline
    rand-tr 1 newline
    rand-tr 2 newline
    rand-tr 3 newline
    rand-tr 4 newline
    rand-tr 5 newline
]]
td-data: does [999 + random 9000]
rand-td: does [form-tag 'td td-data]
rand-tr: func [i][rejoin [
    form-tag 'tr
        rejoin [(form-tag 'td i) rand-td rand-td rand-td]
]]
first-tr: func[][rejoin [
    form-tag 'tr rejoin [
        form-tag 'th ""
        form-tag 'th "X"
        form-tag 'th "Y"
        form-tag 'th "Z"
    ]
]]
form-tag: func [tag contents /attr a][
    ajoin [
        "<" tag (if attr [ajoin [" " a/1 "=" {"} a/2 {"}]]) ">"
        contents
        "</" tag #">"
    ]
]

print form-tag 'table table-rows
