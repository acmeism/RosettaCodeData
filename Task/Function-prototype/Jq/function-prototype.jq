def Func: # no arguments

def Func(a;b): # two arguments

def Vararg(v):
  v as [$a1, $a2] ....  # if v is an array, then $a1 will be the first item specified by v, or else null, and so on

def Vararg(a; v):
  v as [$a1, $a2] ....  # if v is an array, then $a1 will be the first item specified by v, or else null, and so on
