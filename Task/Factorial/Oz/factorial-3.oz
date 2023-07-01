fun {Fac3 N}
   Result = {NewCell 1}
in
   for I in 1..N do
      Result := @Result * I
   end
   @Result
end
