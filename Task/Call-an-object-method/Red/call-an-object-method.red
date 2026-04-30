;-object creation
my-proto: object [
	val1: 2
	val2: 3
	set: func [arg1 arg2] [self/val1: arg1 self/val2: arg2]
	sum: func [][ return (val1 + val2)]
]

;-create an instance
my-obj1: copy my-proto
;-calling internal method to get value
print my-obj1/sum

;-create a new instance
my-obj2: copy my-proto
;- calling an internal mathod to set value
my-obj2/set 1 1
;-calling the get method
print my-obj2/sum

;-calling the get method on the first object
print my-obj1/sum
