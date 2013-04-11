str: "Mary had a <%size%> lamb"
size: "little"
build-markup str

;REBOL3 also has the REWORD function
str: "Mary had a $size lamb"
reword str [size "little"]
