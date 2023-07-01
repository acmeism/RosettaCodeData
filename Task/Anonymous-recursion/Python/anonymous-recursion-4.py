>>> from inspect import currentframe
>>> from types import FunctionType
>>> def myself (*args, **kw):
...    caller_frame = currentframe(1)
...    code = caller_frame.f_code
...    return FunctionType(code, caller_frame.f_globals)(*args, **kw)
...
>>> print "factorial(5) =",
>>> print (lambda n:1 if n<=1 else n*myself(n-1)) ( 5 )
