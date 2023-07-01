textData = read("C:\Ring\ReadMe.txt")
ln =len(textData)
charCount = list(255)
totCount = 0

for i =1 to ln
    char = ascii(substr(textData,i,1))
    charCount[char] = charCount[char] + 1
    if char > 31 totCount = totCount + 1 ok
next

for i = 32 to 255
    if charCount[i] > 0 see char(i) + " = " + charCount[i] + " " + (charCount[i]/totCount)*100 + " %" + nl ok
next
