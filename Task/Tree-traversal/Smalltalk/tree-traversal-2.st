"Protocol: visiting"
Node>>accept: aVisitor
	^aVisitor visit: self

Node>>accept: aVisitor with: anObject
	^aVisitor visit: self with: anObject

"Protocol: accessing"
Node>>data
	^data

Node>>data: anObject
	data := anObject

Node>>left
	^left

Node>>left: aNode
	left := aNode

Node>>right
	^right

Node>>right: aNode
	right := aNode

"Protocol: initialize-release"
Node>>initialize
	super initialize.
	left := right := EmptyNode new

"Class side"
"Protocol: instance creation"
Node class>>data: anObject
	^self new data: anObject
