try:
   foo()
except SillyError, se:
   print se.args
   bar()
else:
   # no exception occurred
   quux()
finally:
   baz()
