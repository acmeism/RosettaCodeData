;; primitive : (number->string number [base]) - default base = 10

(number->string 2 2)
→ 10

(for-each (compose writeln (rcurry number->string 2)) '( 5 50 9000)) →
101
110010
10001100101000
