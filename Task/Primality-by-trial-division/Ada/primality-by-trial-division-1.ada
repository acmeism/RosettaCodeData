function Is_Prime(Item : Positive) return Boolean is
   Test : Natural;
begin
   if Item = 1 then
      return False;
   elsif Item = 2 then
      return True;
   elsif Item mod 2 = 0 then
      return False;
   else
      Test := 3;
      while Test <= Integer(Sqrt(Float(Item))) loop
         if Item mod Test = 0 then
            return False;
         end if;
         Test := Test + 2;
      end loop;
   end if;
   return True;
end Is_Prime;
