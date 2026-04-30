   function Strictly_Ascending(Strings: String_Vec.Vector) return Boolean is
   begin
      for Idx in Strings.First_Index+1 .. Strings.Last_Index loop
	 if Strings(Idx-1) >= Strings(Idx) then
	    return False;
	 end if;
      end loop;
      return True;
   end Strictly_Ascending;
