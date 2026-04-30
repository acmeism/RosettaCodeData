Rebol [
    title: "Rosetta code: Walk a directory/Non-recursively"
    file:  %Walk_a_directory-Non-recursively.r3
    url:   https://rosettacode.org/wiki/Walk_a_directory-Non-recursively
]

for-each-file: function [
    {Walk a directory, evaluating body for each file.}
    directory [file!]   "directory to use"
    body      [block!]  "block evaluated for each matched file"
][
    unless exists? directory: to-real-file directory [exit]
    foreach file read directory [
        try bind body 'file
    ]
]

;; Count number of bytes of all %.r3 files in the current directory
bytes: 0
for-each-file %./ [ if %.r3 == suffix? file [bytes: bytes + size? file] ]
print ["Total bytes:" bytes]
