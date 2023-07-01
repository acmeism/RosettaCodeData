REBOL [
    Title: "Mutual Recursion"
    URL: http://rosettacode.org/wiki/Mutual_Recursion
	References: [http://en.wikipedia.org/wiki/Hofstadter_sequence#Hofstadter_Female_and_Male_sequences]
]

f: func [
	"Female."
	n [integer!] "Value."
] [either 0 = n [1][n - m f n - 1]]

m: func [
	"Male."
	n [integer!] "Value."
] [either 0 = n [0][n - f m n - 1]]

fs: []  ms: []  for i 0 19 1 [append fs f i  append ms m i]
print ["F:" mold fs  crlf  "M:" mold ms]
