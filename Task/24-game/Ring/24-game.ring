# Project : 24 game

load "stdlib.ring"
digits = list(4)
check = list(4)
for choice = 1 to 4
     digits[choice] = random(9)
next

see "enter an equation (using all of, and only, the single digits " + nl
for index = 1 to 4
     see digits[index]
     if index != 4
        see " "
    ok
next
see ")"
see " which evaluates to exactly 24. only multiplication (*), division (/)," + nl
see "addition (+) & subtraction (-) operations and parentheses are allowed:" + nl
see "24 = "
give equation
see "equation = " + equation + nl

while true
        for char = 1 to len(equation)
             digit = substr("0123456789", equation[char]) - 1
             if digit >= 0
                for index = 1 to 4
                     if digit = digits[index]
                        if not check[index]
                           check[index] = 1
                           exit
                        ok
                     ok
                next
                if index > 4
                   see "sorry, you used the illegal digit " + digit + nl
                   exit 2
                ok
            ok
        next
        for index = 1 to 4
             if check[index] = 0
                see "sorry, you failed to use the digit " + digits[index] + nl
                exit 2
             ok
        next
        for pair = 11 to 99
             if substr(equation, string(pair))
                see "sorry, you may not use a pair of digits " + pair + nl
             ok
        next
        eval("result = " + equation)
        if result = 24
           see "congratulations, you succeeded in the task!" + nl
           exit
        else
           see "sorry, your equation evaluated to " + result + " rather than 24!" + nl
        ok
end
