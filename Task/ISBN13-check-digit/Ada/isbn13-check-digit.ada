with Ada.Text_IO;

procedure ISBN_Check is

   function Is_Valid (ISBN : String) return Boolean is
      Odd       : Boolean := True;
      Sum       : Integer := 0;
      Value     : Integer;
   begin
      for I in ISBN'Range loop
         if ISBN (I) in '0' .. '9' then
            Value := Character'Pos (ISBN (I)) - Character'Pos ('0');
            if Odd then
               Sum := Sum + Value;
            else
               Sum := Sum + 3 * Value;
            end if;
            Odd := not Odd;
         end if;
      end loop;
      return Sum mod 10 = 0;
   end Is_Valid;

   procedure Show (ISBN : String) is
      use Ada.Text_IO;
      Valid : constant Boolean := Is_Valid (ISBN);
   begin
      Put (ISBN); Put ("  ");
      Put ((if Valid then "Good" else "Bad"));
      New_Line;
   end Show;
begin
   Show ("978-1734314502");
   Show ("978-1734314509");
   Show ("978-1788399081");
   Show ("978-1788399083");
end ISBN_Check;
