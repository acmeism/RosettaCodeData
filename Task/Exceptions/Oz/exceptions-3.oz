try
   {Foo}
catch sillyError then
   {Bar}
[] slightlyLessSilly(data:D ...) then
   {Quux D}
[] _ then %% an unknown type of exception was thrown
   {Baz}
finally
   {Fin}
end
