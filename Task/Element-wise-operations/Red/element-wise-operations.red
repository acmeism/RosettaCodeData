Red [
	title: "Matrix Element-wise Operations"
	author: "hinjolicious"
	note: "Based on Python and Arturo's examples"
]

#include %transpose.red
;#include %pipe-map.red
;#include %mylib.red
#include %list-comprehension.red

; matrix printer
mat-print: func [m[block!] /padding pd /round-to rt] [
	unless padding [pd: 5]
	unless round-to [rt: 0.001]
	foreach r m [
		prin ["["]  foreach c r [
			prin [" " pad/left round/to c rt pd]
		]  print [" ]"]
	]  print ""
]

; nested lc to do matrix element-wise operations:
print "Matrix element-wise operations using Python's style list comprehension:"

a: [[1 2][3  4][ 5  6]]
b: [[7 8][9 10][11 12]]

mat-op: function [op a b] [
	function [a b] 	replace/deep copy/deep [
		case [
			all [block?  a  number? b] [ lc [ [lc [[ _op e b] | e in r]] | r in a] ]
			all [number? a  block?  b] [ lc [ [lc [[ _op a e] | e in r]] | r in b] ]
			all [block?  a  block?  b] [ lc [ [lc [[ _op e/1 e/2] | e in (transpose r)]] | r in (transpose reduce [a b])] ]	
			true [ print ["Error: a is" type? a "b is" type? b "!"]  none ]
		]
	] '_op op
]

mat-add: mat-op 'add a b
mat-sub: mat-op 'subtract a b
mat-mul: mat-op 'multiply a b
mat-div: mat-op 'divide a b
mat-pow: mat-op 'power a b

; test:

print "a + b ="   mat-print mat-add a b
print "a - b ="   mat-print mat-sub a b
print "a - 10 ="  mat-print mat-sub a 10
print "10 - b ="  mat-print mat-sub 10 b
print "a x b ="   mat-print mat-mul a b
print "a x 10 ="  mat-print mat-mul a 10
print "a / b ="   mat-print mat-div a b
print "a / 10 ="  mat-print mat-div a 10
print "a ^^ 2 ="  mat-print mat-pow b 2
