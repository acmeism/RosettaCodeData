REBOL [
   Title: "Notes"
   URL: http://rosettacode.org/wiki/Take_notes_on_the_command_line
]

notes: %notes.txt

either any [none? args: system/script/args  empty? args] [
   if exists? notes [print read notes]
] [
   write/binary/append notes rejoin [now lf tab args lf]
]
