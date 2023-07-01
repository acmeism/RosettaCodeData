try:
   foo()
except SillyError as se:
   print(se.args)
   bar()
else:
   # no exception occurred
   quux()
finally:
   baz()
