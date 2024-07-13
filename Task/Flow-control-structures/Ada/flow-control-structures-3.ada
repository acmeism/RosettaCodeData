Outer:
loop
   -- do something
   loop
      exit Outer when Finished;
      -- do something else
   end loop;
end loop Outer;
