with My_Package; use My_Package;

procedure Main is
   Foo : My_Type; -- Foo is created and initialized to -12
begin
   Some_Procedure(Foo); -- Foo is doubled
   Foo := Set(2007); -- Foo.Variable is set to 2007
end Main;
