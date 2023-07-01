>>> original = 'Mary had a {extra} lamb.'
>>> extra = 'little'
>>> original.format(**locals())
'Mary had a little lamb.'
