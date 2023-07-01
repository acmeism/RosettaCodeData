map = [7:7, foo:'foovalue', bar:'barvalue', moo:'moovalue']

assert 7 == map[7]
assert 'foovalue' == map.foo
assert 'barvalue' == map['bar']
assert 'moovalue' == map.get('moo')
