;; String creation and destruction
str: make string! 5
str: none
;; String assignment
str: "Hello"
;; String comparison
str == "Hello" ;; case sensitive
str = "hello"  ;; case insensitive
;; String cloning and copying
tmp: copy str
;; Check if a string is empty
empty? tmp
clear tmp
empty? tmp
;; Append a byte to a string
append tmp "x"       ;== "x"
append/dup tmp "y" 2 ;== "xyy"
;; Extract a substring from a string
copy/part next tmp 2 ;== "yy"
;; Replace every occurrence of a byte (or a string) in a string with another string
replace/all str "l" "L"
;; Join strings
join str tmp
rejoin [str space tmp]
ajoin [str space tmp]
