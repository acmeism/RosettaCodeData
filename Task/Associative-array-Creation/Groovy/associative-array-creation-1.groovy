map = [:]
map[7] = 7
map['foo'] = 'foovalue'
map.put('bar', 'barvalue')
map.moo = 'moovalue'

assert 7 == map[7]
assert 'foovalue' == map.foo
assert 'barvalue' == map['bar']
assert 'moovalue' == map.get('moo')
