procedure main()
   x := foo()
   y := foo2()

   x.a()                                      # example of normal method call
   DynMethod(x,"a")                           # using DynMethod
   DynMethod(x,"simplydoesntexist")           # results in error
   DynMethod(y,"simplydoesntexist")           # catches error
   DynMethod(y,"simplydoesntexist",1,2,3,4,5) # with parameters
end

class foo(A) # sample class and methods
   method a(p1)
      l1 := p1
      return
   end
   method b(p2)
      l2 := p2
      return
   end
   initially
      i1 := 0
      return
end

class foo2 : foo (A)
   method UndefinedMethod(x[])  # Undefined Method handler
      write(&errout,"You called an undefinded method of this object.")
      return
   end
end
