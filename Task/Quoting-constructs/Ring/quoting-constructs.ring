text = list(3)

text[1] = "This is 'first' example for quoting"
text[2] = "This is second 'example' for quoting"
text[3] = "This is third example 'for' quoting"

for n = 1 to len(text)
    see "text for quoting: " + nl + text[n] + nl
    str = substr(text[n],"'","")
    see "quoted text:" + nl + str + nl + nl
next
