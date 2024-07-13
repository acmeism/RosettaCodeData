Outer:
loop
   -- do something
   loop
      if Finished then
         exit Outer; -- exits both the inner and outer loops
      end if;
      -- do something else
   end loop;
end loop Outer;
