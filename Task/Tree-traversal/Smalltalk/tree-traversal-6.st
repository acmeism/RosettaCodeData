"Protocol: visiting"
PostOrder>>visit: aNode
	aNode left accept: self.
	aNode right accept: self.
	block value: aNode
