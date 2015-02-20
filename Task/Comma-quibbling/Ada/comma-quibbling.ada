with Ada.Text_IO, Ada.Command_Line; use Ada.Command_Line;

procedure Comma_Quibble is

begin
   case Argument_Count is
      when 0 => Ada.Text_IO.Put_Line("{}");
      when 1 => Ada.Text_IO.Put_Line("{" & Argument(1) & "}");
      when others =>
	 Ada.Text_IO.Put("{");
	 for I in 1 .. Argument_Count-2 loop
	    Ada.Text_IO.Put(Argument(I) & ", ");
	 end loop;
	 Ada.Text_IO.Put(Argument(Argument_Count-1) & " and " &
		         Argument(Argument_Count) & "}");
   end case;
end Comma_Quibble;
