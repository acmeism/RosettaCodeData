define mytype => type {
	data
		public id::integer		= 0,
		public val::string		= '',
		public rand::integer	= 0

	public onCreate() => {
		// "onCreate" runs when instance created, populates .rand
		.rand = math_random(50,1)
	}
	public asString() => {
		return 'has a value of: "'+.val+'" and a rand number of "'+.rand+'"'
	}
	
}

local(x = mytype)
#x->val = '99 Bottles of beer'
#x->asString // outputs 'has a value of: "99 Bottles of beer" and a rand number of "48"'
