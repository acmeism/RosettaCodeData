Rebol [
    title: "Rosetta code: Write entire file"
    file:  %Write_entire_file.r3
    url:   https://rosettacode.org/wiki/Write_entire_file
]

;; simple direct write
write %test.txt "Hello, world!"
print read/string %test.txt

;; using port (/new overwrites)
port: open/new %test.txt
write port "Hello from Rebol!"
close port
print read/string %test.txt

;; cleanup
delete %test.txt
