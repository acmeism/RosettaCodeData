Red []
print "Evaluation from left to right with no precedence, unless you use parenthesis." print ""
a: "123456789"
guess: ""
valid: ""
sucess: false
random/seed now/time
loop 4 [append valid last random a]
print ["The numbers are: " valid/1 ", " valid/2 ", " valid/3 " and " valid/4]
sort valid
insert valid " "

expr:    [term ["+" | "-"] expr | term]
term:    [primary ["*" | "/"] term | primary]
primary: [some digit | "(" expr ")"]
digit:   charset valid

while [not sucess] [
	guess: ask "Enter your expression: "
	if guess = "q" [halt]
	numbers: copy guess
	sort numbers
	numbers: take/last/part numbers 4
	insert numbers " "
	either (parse guess expr) and (valid = numbers) [
		repeat i length? guess [insert at guess (i * 2) " "]
		result: do guess
		print ["The result of your expression is: " result]
		if (result = 24) [sucess: true]
	][
	print "Something is wrong with the expression, try again."
	]
]
print "You got it right!"
