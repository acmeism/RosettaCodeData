Red [
	Title: "Long multiplication"
	Author: "hinjolicious"
	Resources: "Red Sensei"
]

char-to-num: function [c][-48 + c]
num-to-char: function [n][#"0" + n]

; Simple long multiplication (positive numbers only!)

long-mult: function [sa [string!] sb [string!] /trace] [
    la: length? sa
    lb: length? sb

    ; Initialize result array with zeros
    sr: append/dup copy "" "0" (la + lb)

    ; Multiply each digit
    i: la while [i > 0] [
        j: lb while [j > 0] [
            a: char-to-num sa/:i
            b: char-to-num sb/:j
			
            k: i + j - 1
            kk: i + j
            m: (a * b) + (char-to-num sr/:kk)

            sr/:kk: num-to-char (m % 10)
            sr/:k: num-to-char (char-to-num sr/:k + (m / 10))
			if trace [?? sr]
        j: j - 1]
    i: i - 1]
	parse sr [remove some #"0"]
	if empty? sr [sr: "0"]
	sr
]

print long-mult "18446744073709551616" "18446744073709551616"
print long-mult "340282366920938463463374607431768211456" "340282366920938463463374607431768211456"
