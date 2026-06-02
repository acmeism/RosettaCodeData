Rebol [
    title: "Rosetta code: Truncate a file"
    file:  %Truncate_a_file.r3
    url:    https://rosettacode.org/wiki/Truncate_a_file
]

truncate: function [
    {Truncates a file to the specified number of bytes.}
    file  [file!]    "The file to truncate"
    bytes [integer!] "The number of bytes to keep"
][
    ;; Naive approach:
    ;;     write file read/part file bytes
    ;; But better:
    attempt [
        close clear skip open/seek file bytes
        file
    ]
]

;; Write "Rosetta" repeated 1000 times as binary to file
write %truncate-test append/dup #{} "Rosetta" 1000
;; Print original file size
print ["Original file" %truncate-test "has" size? %truncate-test "bytes."]
;; Truncate the file
truncate %truncate-test 100
;; Print truncated file size
print ["Truncated file" %truncate-test "has" size? %truncate-test "bytes."]
;; Cleanup
delete %truncate-test
