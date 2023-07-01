Token: 3
	Output: 3
	Operators:
Token: +
	Output: 3
	Operators: +
Token: 4
	Output: 3 4
	Operators: +
Token: *
	Output: 3 4
	Operators: + *
Token: 2
	Output: 3 4 2
	Operators: + *
Token: /
	Output: 3 4 2
	Operators: + * /
Token: (
	Output: 3 4 2
	Operators: + * / (
Token: 1
	Output: 3 4 2 1
	Operators: + * / (
Token: -
	Output: 3 4 2 1
	Operators: + * / ( -
Token: 5
	Output: 3 4 2 1 5
	Operators: + * / ( -
Token: )
	Output: 3 4 2 1 5 -
	Operators: + * /
Token: ^
	Output: 3 4 2 1 5 -
	Operators: + * / ^
Token: 2
	Output: 3 4 2 1 5 - 2
	Operators: + * / ^
Token: ^
	Output: 3 4 2 1 5 - 2
	Operators: + * / ^ ^
Token: 3
	Output: 3 4 2 1 5 - 2 3
	Operators: + * / ^ ^
End parsing
	Output: 3 4 2 1 5 - 2 3 ^ ^ / * +
	Operators:
