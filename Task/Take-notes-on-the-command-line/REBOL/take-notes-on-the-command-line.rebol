REBOL [
   Title: "Notes"
   Author: oofoe
   Date: 2010-10-04
   URL: http://rosettacode.org/wiki/Take_notes_on_the_command_line
]

notes: %notes.txt

either any [none? args: system/script/args  empty? args] [
   if exists? notes [print read notes]
] [
   write/binary/append notes rejoin [now lf tab args lf]
]
