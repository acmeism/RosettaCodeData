  DECLARE SUB MyClassDelete (pthis AS MyClass)
  DECLARE SUB MyClassSomeMethod (pthis AS MyClass)
  DECLARE SUB MyClassInit (pthis AS MyClass)

  TYPE MyClass
    Variable AS INTEGER
  END TYPE

  DIM obj AS MyClass
  MyClassInit obj
  MyClassSomeMethod obj

  SUB MyClassInit (pthis AS MyClass)
    pthis.Variable = 0
  END SUB

  SUB MyClassSomeMethod (pthis AS MyClass)
    pthis.Variable = 1
  END SUB
