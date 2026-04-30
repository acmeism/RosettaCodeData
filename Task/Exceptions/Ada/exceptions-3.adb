  ...
exception
   when Foo_Error =>
      if ... then -- Alas, cannot handle it here,
         raise;   -- continue propagation of
      end if;
