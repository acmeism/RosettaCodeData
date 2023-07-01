Red []

csv: {Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!}

add2html: func [ bl ] [append html rejoin bl ]  ;; helper function to add block data to html string

;;----------------------------------------------------------------------
csv2html: func ["function to generate string with html table from csv data file"
;;----------------------------------------------------------------------
    s [string!] "input .csv data"
][
arr: split s newline    ;; generate array (series) from string
html: copy "<table border=1>^/" ;; init html string

forall arr  [  ;; i use forall here so that i can test for head? of series ...
  either head? arr [ append html "<tr bgcolor=wheat>"]
                      [ append html "<tr>"]
  replace/all first arr "<" "&lt;"    ;; escape "<" and ">" characters
  replace/all first arr ">" "&gt;"
  foreach col split first arr "," [
      either head? arr [
        add2html ['<th> col '</th>]
      ][
        add2html ['<td> col '</td>]
      ]
  ]
  add2html ['</tr> newline]
]
return add2html ['</table>]
]
;;----------------------------------------------------------------------

print csv2html csv                 ;; call function
write %data.html csv2html csv   ;; write to file
