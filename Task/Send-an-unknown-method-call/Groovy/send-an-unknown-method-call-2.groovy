procedure main()
   x := foo()    # create object
   x.m1()        # static call of m1 method
   #  two examples where the method string can be dynamically constructed ...
   "foo_m1"(x)   # ... need to know class name and method name to construct name
   x.__m["m1"]   # ... general method (better)
end

class foo(a,b,c) # define object
method m1(x)
end
end
