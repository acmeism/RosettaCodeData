load "stdlib.ring"

table1 = "A or B"
table2 = "A and B"
vars = ["A", "B"]

see table1 + nl
see "A | B | Output" + nl
see "----------" + nl
result("A","B",table1)
see nl+table2 + nl
see "A | B | Output" + nl
see "----------" + nl
result("A","B",table2)

func result(A,B,table)
for a_res = 0 to 1
    for b_res = 0 to 1
        A = a_res
        B = b_res

        output = eval("return " + table)

        see "" + A + " | " + B + " | " + output + nl
    next
next
