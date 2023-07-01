define mytype => type {
	public foo() => {
		return 'foo was called'
	}
	public bar() => {
		return 'this time is was bar'
	}
}
local(obj = mytype, methodname = tag('foo'), methodname2 = tag('bar'))
#obj->\#methodname->invoke
#obj->\#methodname2->invoke
