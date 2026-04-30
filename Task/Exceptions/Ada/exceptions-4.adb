procedure Call_Foo is
begin
   Foo;
exception
   when Foo_Error =>
      ... -- do something
   when others =>
      ... -- this catches all other exceptions
end Call_Foo;
