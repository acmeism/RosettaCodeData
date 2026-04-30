with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with GNAT.Expect;            use GNAT.Expect;
with GNAT.OS_Lib;            use GNAT.OS_Lib;
with GNAT.String_Split;      use GNAT.String_Split;

procedure System_Command is
   Command    : String          := "ls -l";
   Args       : Argument_List_Access;
   Status     : aliased Integer;
   Separators : constant String := LF & CR;
   Reply_List : Slice_Set;

begin
   Args := Argument_String_To_List (Command);
   -- execute the system command and get the output in a single string
   declare
      Response : String :=
        Get_Command_Output
          (Command   => Args (Args'First).all,
           Arguments => Args (Args'First + 1 .. Args'Last),
           Input     => "",
           Status    => Status'Access);
   begin
      Free (Args);
      -- split the output in a slice for easier manipulation
      if Status = 0 then
         Create (S          => Reply_List,
                 From       => Response,
                 Separators => Separators,
                 Mode       => Multiple);
      end if;
   end;
   -- do something with the system output. Just print it out
   for I in 1 .. Slice_Count (Reply_List) loop
      Put_Line (Slice (Reply_List, I));
   end loop;

end System_Command;
