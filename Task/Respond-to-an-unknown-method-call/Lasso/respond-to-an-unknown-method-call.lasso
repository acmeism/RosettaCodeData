define exampletype => type {
	public foo() => {
		return 'this is foo\r'
	}
	public bar() => {
		return 'this is bar\r'
	}
	public _unknownTag(...) => {
		local(n = method_name->asString)
		return 'tried to handle unknown method called "'+#n+'"'+
			(#rest->size ? ' with args: "'+#rest->join(',')+'"')+'\r'
	}
}

local(e = exampletype)

#e->foo()
// outputs 'this is foo'

#e->bar()
// outputs 'this is bar'

#e->stuff()
// outputs 'tried to handle unknown method called "stuff"'

#e->dothis('here',12,'there','nowhere')
// outputs 'tried to handle unknown method called "dothis" with args: "here,12,there,nowhere"'
