"Protocol: visiting"
PreOrder>>visit: aNode
	block value: aNode.
	aNode left accept: self.
	aNode right accept: self
