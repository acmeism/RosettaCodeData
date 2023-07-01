   function All_Are_The_Same(Strings: String_Vec.Vector) return Boolean is
   begin
      for Idx in Strings.First_Index .. Strings.Last_Index-1 loop
	 if Strings(Idx) /= Strings(Idx+1) then
	    return False;
	 end if;
      end loop;
      return True;
   end All_Are_The_Same;
