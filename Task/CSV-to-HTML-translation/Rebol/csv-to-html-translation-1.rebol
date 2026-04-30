Rebol [
    title: "Rosetta code: CSV to HTML translation"
    file:  %CSV_to_HTML_translation.r3
    url:   https://rosettacode.org/wiki/CSV_to_HTML_translation
    needs: 3.15.0 ;; or something like that
]
import csv

csv-to-html: function/with [
    "Generate string with html table from csv data file"
    csv [string! file!] "input .csv data"
][
    escape-html csv

    data: decode 'csv csv
    html: copy "<table border=1>^/"

    emit-row/head data/1
    foreach row next data [ emit-row row ]
    emit </table>
][
    html: none
    emit: func [val][
        if block? val [val: ajoin val]
        append html val
    ]
    emit-row: func[row /head][
        emit ["<tr" if head [" bgcolor=wheat"] ">"]
        foreach col row [
            emit-tag either head ['th]['td] col
        ]
        emit "</tr>^/"
    ]
    emit-tag: func [tag content][
        emit [#"<" tag #">" content "</" tag #">"]
    ]
    escape-html: function/with [str][
        parse str [any[
            to esc [
                  change #"<" "&lt;"
                | change #">" "&gt;"
                | change #"&" "&amp;"
            ]
        ]]
    ][  esc: charset "<>&" ]
]

print csv-to-html {Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!}
