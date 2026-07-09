Rebol [
    title: "Rosetta code: Substring/Top and tail"
    file:  %Substring-Top_and_tail.r3
    url:   https://rosettacode.org/wiki/Substring/Top_and_tail
]

str: "upraisers"
print ["Full String:  "  str]
print ["Without_First: " copy next str]
print ["Without_Last: "  copy/part str str/length - 1]
print ["Without_Both:  " copy/part next str str/length - 2]
print ""

;; When it's ok to modify existing string
probe remove "upraisers"   ;== "praisers"
;; Using take
str: "upraisers"
probe take      str        ;== #"u"
probe take/last str        ;== #"s"
probe str                  ;== "praiser"
probe take/part str 2      ;== "pr"
probe take/last/part str 3 ;== "ser"
probe str                  ;== "ai"
