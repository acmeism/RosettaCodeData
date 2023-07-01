s = ''
# or:
s = str()

if not s or s == '':
   print("String is empty")

if len(s) == 0:
    print("String is empty")
else:
    print("String not empty")


# boolean test function for python2 and python3
# test for regular (non-unicode) strings
# unicode strings
# None
def emptystring(s):
   if isinstance(s, (''.__class__ , u''.__class__) ):
      if len(s) == 0:
         return True
      else
         return False

   elif s is None:
        return True
