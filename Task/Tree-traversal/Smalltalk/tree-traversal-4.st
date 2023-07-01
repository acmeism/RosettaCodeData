"Protocol: visiting"
InOrder>>visit: aNode
	aNode left accept: self.
	block value: aNode.
	aNode right accept: self
