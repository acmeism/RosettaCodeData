with ada.text_io,Ada.Strings.Unbounded; use  ada.text_io, Ada.Strings.Unbounded;

procedure menu is
	type menu_strings is array (positive range <>) of Unbounded_String ;
	function "+" (s : string) return Unbounded_String is (To_Unbounded_String (s));

	function choice (m : menu_strings; prompt : string) return string is
	begin
		if m'length > 0 then
			loop
				put_line (prompt);
				for i in m'range loop
					put_line (i'img &") " & To_String (m(i)));
				end loop;
				begin
					return To_String (m(positive'value (get_line)));
					exception when others => put_line ("Try again !");
				end;
			end loop;
		end if;
		return "";
	end choice;

begin
	put_line ("You chose " &
		choice ((+"fee fie",+"huff and puff",+"mirror mirror",+"tick tock"),"Enter your choice "));
end menu;
