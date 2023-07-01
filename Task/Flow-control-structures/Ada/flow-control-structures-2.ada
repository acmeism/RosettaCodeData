Outer:
   loop
      -- do something
      loop
         -- do something else
         exit Outer; -- exits both the inner and outer loops
      end loop;
   end loop;
