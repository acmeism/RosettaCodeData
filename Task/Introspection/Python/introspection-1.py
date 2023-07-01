# Checking for system version
 import sys
 major, minor, bugfix = sys.version_info[:3]
 if major < 2:
     sys.exit('Python 2 is required')


 def defined(name): # LBYL (Look Before You Leap)
     return name in globals() or name in locals() or name in vars(__builtins__)

 def defined2(name): # EAFP (Easier to Ask Forgiveness than Permission)
     try:
          eval(name)
          return True
     except NameError:
          return False

 if defined('bloop') and defined('abs') and callable(abs):
     print abs(bloop)

 if defined2('bloop') and defined2('abs') and callable(abs):
     print abs(bloop)
