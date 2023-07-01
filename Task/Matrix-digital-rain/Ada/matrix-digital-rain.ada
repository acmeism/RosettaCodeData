with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Fixed;

procedure Digital_Rain is
   type Column_Type     is range 0 .. 150;
   type Row_Type        is range 0 .. 25;
   type Character_Range is new Character range 'A' .. 'Z';
   subtype Delay_Range  is Integer range 2 .. 6;

   package Column_Random    is new Ada.Numerics.Discrete_Random (Column_Type);
   package Row_Random       is new Ada.Numerics.Discrete_Random (Row_Type);
   package Character_Random is new Ada.Numerics.Discrete_Random (Character_Range);
   package Delay_Random     is new Ada.Numerics.Discrete_Random (Delay_Range);

   Column_Generator    : Column_Random.Generator;
   Row_Generator       : Row_Random.Generator;
   Character_Generator : Character_Random.Generator;
   Delay_Generator     : Delay_Random.Generator;

   Esc     : constant Character := Character'Val (8#33#);
   Running : Boolean   := True;
   Char    : Character;
   use Ada.Text_IO;

   protected Text_Out is
      procedure Put_At (Row : Row_Type; Col : Column_Type;
                        Color : Integer; Item : Character);
   end Text_Out;

   protected body Text_Out is
      procedure Put_At (Row : Row_Type; Col : Column_Type;
                        Color : Integer; Item : Character)
      is
         use Ada.Strings;
      begin
         Put (Esc & "[" &
                Fixed.Trim (Row'Image, Left) & ";" &
                Fixed.Trim (Col'Image, Left) & "H");             -- Place Cursor
         Put (Esc & "[" & Fixed.Trim (Color'Image, Left) & "m"); -- Foreground color
         Put (Item);
      end Put_At;
   end Text_Out;

   task type Rainer;

   task body Rainer is
      Row : Row_Type;
      Col : Column_Type;
      Del : Delay_Range;
   begin
      Outer_Loop:
      loop
         Col := Column_Random.Random (Column_Generator);
         Row := Row_Random.Random (Row_Generator);
         for Rain in reverse Boolean loop
            Del := Delay_Random.Random (Delay_Generator);
            for R in 0 .. Row loop
               if Rain then
                  if R in 1 .. Row then
                     Text_Out.Put_At (R - 1, Col, Color => 32, Item => Char);
                  end if;
                  Char := Character (Character_Random.Random (Character_Generator));
                  if R in 0 .. Row - 1 then
                     Text_Out.Put_At (R, Col, Color => 97, Item => Char);
                  end if;
               else
                  Text_Out.Put_At (R, Col, Color => 30, Item => ' ');
               end if;
               delay 0.020 * Del;
               exit Outer_Loop when not Running;
            end loop;
         end loop;
      end loop Outer_Loop;
   end Rainer;

   Dummy   : Character;
   Rainers : array (1 .. 50) of Rainer;
begin
   Put (ESC & "[?25l");        -- Hide the cursor
   Put (ESC & "[40m");         -- Black background
   Put (ESC & "[2J");          -- Clear Terminal

   Get_Immediate (Dummy);
   Running := False;
   delay 0.200;

   Put (ESC & "[?25h");        -- Restore the cursor
   Put (ESC & "[0;0H");        -- Place cursor
   Put (ESC & "[39m");         -- Default foreground
   Put (ESC & "[49m");         -- Default backgound
   Put (ESC & "[2J");          -- Clear Terminal
end Digital_Rain;
