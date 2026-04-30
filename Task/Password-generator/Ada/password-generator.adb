with Ada.Numerics.Discrete_Random;
with Ada.Strings.Fixed;
with Ada.Command_Line;
with Ada.Integer_Text_IO;
with Ada.Text_IO;

procedure Mkpw is

   procedure Put_Usage;
   procedure Parse_Command_Line (Success : out Boolean);
   function Create_Password (Length : in Positive;
                             Safe   : in Boolean)
                            return String;

   procedure Put_Usage is
      use Ada.Text_IO;
   begin
      Put_Line ("Usage:                                                     ");
      Put_Line ("   mkpw help   - Show this help text                       ");
      Put_Line ("   mkpw [count <n>] [length <l>] [seed <s>] [safe]         ");
      Put_Line ("     count <n>  - Number of passwords generated (default 4)");
      Put_Line ("     length <l> - Password length (min 4)       (default 4)");
      Put_Line ("     seed <l>   - Seed for random generator     (default 0)");
      Put_Line ("     safe       - Do not use unsafe characters  (0O1lIS52Z)");
   end Put_Usage;

   Lower_Set  : constant String := "abcdefghijklmnopqrstuvwxyz";
   Upper_Set  : constant String := "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   Digit_Set  : constant String := "0123456789";
   Spec_Set   : constant String := "!""#$%&'()*+,-./:;<=>?@[]^_{|}~";
   Unsafe_Set : constant String := "0O1lI5S2Z";

   Full_Set : constant String := Lower_Set & Upper_Set & Digit_Set & Spec_Set;
   subtype Full_Indices is Positive range Full_Set'Range;

   package Full_Index_Generator is
      new Ada.Numerics.Discrete_Random (Full_Indices);

   Index_Generator : Full_Index_Generator.Generator;

   Config_Safe          : Boolean  := False;
   Config_Count         : Natural  := 4;
   Config_Length        : Positive := 6;
   Config_Seed          : Integer  := 0;
   Config_Show_Help     : Boolean  := False;

   procedure Parse_Command_Line (Success : out Boolean) is
      use Ada.Command_Line;
      Got_Safe,   Got_Count : Boolean  := False;
      Got_Length, Got_Seed  : Boolean  := False;
      Last       : Positive;
      Index      : Positive := 1;
   begin
      Success := False;
      if Argument_Count = 1 and then Argument (1) = "help" then
         Config_Show_Help := True;
         return;
      end if;

      while Index <= Argument_Count loop
         if Ada.Command_Line.Argument (Index) = "safe" then
            if Got_Safe then
               return;
            end if;
            Got_Safe := True;
            Config_Safe     := True;
            Index := Index + 1;
         elsif Argument (Index) = "count" then
            if Got_Count then
               return;
            end if;
            Got_Count := True;
            Ada.Integer_Text_IO.Get (Item => Config_Count,
                                     From => Argument (Index + 1),
                                     Last => Last);
            if Last /= Argument (Index + 1)'Last then
               return;
            end if;
            Index := Index + 2;
         elsif Argument (Index) = "length" then
            if Got_Length then
               return;
            end if;
            Got_Length := True;
            Ada.Integer_Text_IO.Get (Item => Config_Length,
                                     From => Argument (Index + 1),
                                     Last => Last);
            if Last /= Argument (Index + 1)'Last then
               return;
            end if;
            if Config_Length < 4 then
               return;
            end if;
            Index := Index + 2;
         elsif Argument (Index) = "seed" then
            if Got_Seed then
               return;
            end if;
            Got_Seed := True;
            Ada.Integer_Text_IO.Get (Item => Config_Seed,
                                     From => Argument (Index + 1),
                                     Last => Last);
            if Last /= Argument (Index + 1)'Last then
               return;
            end if;
            Index := Index + 2;
         else
            return;
         end if;
      end loop;
      Success := True;
   exception
      when Constraint_Error | Ada.Text_IO.Data_Error =>
         null;
   end Parse_Command_Line;

   function Create_Password (Length : in Positive;
                             Safe   : in Boolean)
                            return String
   is

      function Get_Random (Safe : in Boolean)
                          return Character;

      function Get_Random (Safe : in Boolean)
                          return Character
      is
         use Ada.Strings.Fixed;
         C : Character;
      begin
         loop
            C := Full_Set (Full_Index_Generator.Random (Index_Generator));
            if Safe then
               exit when Index (Source => Unsafe_Set, Pattern => "" & C) = 0;
            else
               exit;
            end if;
         end loop;
         return C;
      end Get_Random;

      function Has_Four (Item : in String)
                        return Boolean;

      function Has_Four (Item : in String)
                        return Boolean
      is
         use Ada.Strings.Fixed;
         Has_Upper, Has_Lower : Boolean := False;
         Has_Digit, Has_Spec  : Boolean := False;
      begin
         for C of Item loop
            if Index (Upper_Set, "" & C) /= 0 then Has_Upper := True; end if;
            if Index (Lower_Set, "" & C) /= 0 then Has_Lower := True; end if;
            if Index (Digit_Set, "" & C) /= 0 then Has_Digit := True; end if;
            if Index (Spec_Set,  "" & C) /= 0 then Has_Spec  := True; end if;
         end loop;
         return Has_Upper and Has_Lower and Has_Digit and Has_Spec;
      end Has_Four;

      Password : String (1 .. Length);
   begin
      loop
         for I in Password'Range loop
            Password (I) := Get_Random (Safe);
         end loop;
         exit when Has_Four (Password);
      end loop;
      return Password;
   end Create_Password;

   Parse_Success : Boolean;
begin

   Parse_Command_Line (Parse_Success);

   if Config_Show_Help or not Parse_Success then
      Put_Usage;  return;
   end if;

   if Config_Seed = 0 then
      Full_Index_Generator.Reset (Index_Generator);
   else
      Full_Index_Generator.Reset (Index_Generator, Config_Seed);
   end if;

   for Count in 1 .. Config_Count loop
      Ada.Text_IO.Put_Line (Create_Password (Length => Config_Length,
                                             Safe   => Config_Safe));
   end loop;

end Mkpw;
