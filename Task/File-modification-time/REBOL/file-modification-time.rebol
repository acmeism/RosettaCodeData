Rebol [
    title: "Rosetta code: File modification time"
    file:  %File_modification_time.r3
    url:   https://rosettacode.org/wiki/File_modification_time
]

;; Get path to the current script:
file: system/options/script
;; Print info:
print [
    "^/Current script:" to-local-file file
    "^/File size:" size? file
    "^/Modified :" modified? file
]

;; Get some info using `query`:
prin "Parial info: "
probe query file [modified created size]

prin "Just values: "
probe query file [:modified :created :size]

;; It is also possoible get info as an object:
print ""
probe query file object!
