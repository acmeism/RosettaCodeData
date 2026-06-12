function Find_First (List  : in Array_Type; Value : in Integer) return Ret_Val is
begin
   for I in List'Range loop
      if List (I) = Value then
         return (Found => True, Position => I);
      end if;
   end loop;
   return (Found => False);
end Find_First;
