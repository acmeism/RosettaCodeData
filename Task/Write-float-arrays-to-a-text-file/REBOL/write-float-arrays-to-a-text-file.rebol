Rebol [
    title: "Rosetta code: Write float arrays to a text file"
    file:  %Write_float_arrays_to_a_text_file.r3
    url:   https://rosettacode.org/wiki/Write_float_arrays_to_a_text_file
]

form-decimal: function [num precision][
    p: system/options/decimal-digits
    system/options/decimal-digits: precision
    also mold num
    system/options/decimal-digits: p
]

print "Having:"
x: [1 2 3 1e11]
y: [1 1.4142135623730951 1.7320508075688772 316227.76601683791]
?? x
?? y

print "^/Writting decimals with custom precisions:"
echo %out.txt ;; echo console output to the file
i: 0
while [all [++ i xi: x/:i yi: y/:i]][
    print [form-decimal xi 3 TAB form-decimal yi 5]
]
echo none     ;; stop the echo

print "^/Written data:"
print read/string %out.txt

;; Delete the file
delete %out.txt
