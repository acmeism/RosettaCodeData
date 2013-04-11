>>> a = 'hello'
>>> b = ''.join(a)
>>> a == b
True
>>> b is a  ### Might be True ... depends on "interning" implementation details!
False
