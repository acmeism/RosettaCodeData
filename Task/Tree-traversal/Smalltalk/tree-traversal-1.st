"Protocol: visiting"
EmptyNode>>accept: aVisitor

EmptyNode>>accept: aVisitor with: anObject
	^anObject

"Protocol: enumerating"
EmptyNode>>traverse: aVisitorClass do: aBlock
	^self accept: (aVisitorClass block: aBlock)
