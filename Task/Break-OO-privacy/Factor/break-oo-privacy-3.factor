link printf

procedure main()
   (x := foo(1,2,3)).print()                 # create and show a foo
   printf("Fieldnames of foo x : ")          # show fieldnames
   every printf(" %i",fieldnames(x))         # __s (self), __m (methods), vars
   printf("\n")
   printf("var 1 of foo x = %i\n", x.var1)   # read var1 from outside x
   x.var1 := -1                              # change var1 from outside x
   x.print()                                 # show we changed it
end

class foo(var1,var2,var3)                    # class with no set/read methods
   method print()
      printf("foo var1=%i, var2=%i, var3=%i\n",var1,var2,var3)
   end
end
