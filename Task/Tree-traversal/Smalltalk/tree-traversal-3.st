"Protocol: visiting"
visit: aNode
	self subclassResponsibility

"Protocol: accessing"
Visitor>>block: anObject
	block := anObject

"Protocol: initialize-release"
Visitor>>initialize
	super initialize.
	block := [:node | ]

"Class side"
"Protocol: instance creation"
Visitor class>>block: aBlock
	^self new block: aBlock
