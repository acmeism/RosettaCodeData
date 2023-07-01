"Protocol: visiting"
LevelOrder>>visit: aNode
	| queue |
	queue := OrderedCollection with: aNode.
	[(queue removeFirst accept: self with: queue) isEmpty] whileFalse

LevelOrder>>visit: aNode with: aQueue
	block value: aNode.
	^aQueue
		add: aNode left;
		add: aNode right;
		yourself
