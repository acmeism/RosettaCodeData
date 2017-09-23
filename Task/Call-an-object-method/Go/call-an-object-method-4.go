procedure main()

   bar := foo()  # create instance
   bar.m2()      # call method m2 with self=bar, an implicit first parameter

   foo_m1( , "param1", "param2")  # equivalent of static class method, first (self) parameter is null
end

class foo(cp1,cp2)
   method m1(m1p1,m1p2)
      local ml1
      static ms1
      ml1 := m1p1
      # do something
      return
   end
   method m2(m2p1)
      # do something else
      return
   end
initially
   L := [cp1]
end
