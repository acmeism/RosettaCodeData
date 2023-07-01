>>> from string import Template
>>> original = Template('Mary had a $extra lamb.')
>>> extra = 'little'
>>> original.substitute(**locals())
'Mary had a little lamb.'
