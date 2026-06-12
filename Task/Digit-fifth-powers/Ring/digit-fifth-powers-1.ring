? "working..."

sumEnd = 0
sumList = ""

pow5 = []
for i = 1 to 9
    add(pow5, pow(i, 5))
next

limitStart = 2
limitEnd = 6 * pow5[9]

for n = limitStart to limitEnd
    sum = 0
    m = n
    while m > 0
        d = m % 10
        if d > 0 sum += pow5[d] ok
        m = unsigned(m, 10, "/")
    end
    if sum = n
       sumList += "" + n + " + "
       sumEnd += n
    ok
next

? "The sum of all the numbers that can be written as the sum of fifth powers of their digits:"
? substr(sumList, 1, len(sumList) - 2) + "= " + sumEnd
? "done..."
