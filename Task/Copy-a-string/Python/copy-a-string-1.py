>>> src = "hello"
>>> a = src
>>> b = src[:]
>>> import copy
>>> c = copy.copy(src)
>>> d = copy.deepcopy(src)
>>> src is a is b is c is d
True
