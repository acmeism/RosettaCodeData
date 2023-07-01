with Ada.Characters.Latin_1;  use Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;     use Ada.Integer_Text_IO;
with Ada.Streams.Stream_IO;   use Ada.Streams.Stream_IO;

function Get_PPM (File : File_Type) return Image is
   use Ada.Characters.Latin_1;
   use Ada.Integer_Text_IO;

   function Get_Line return String is -- Skips comments
      Byte   : Character;
      Buffer : String (1..80);
   begin
      loop
         for I in Buffer'Range loop
            Character'Read (Stream (File), Byte);
            if Byte = LF then
               exit when Buffer (1) = '#';
               return Buffer (1..I - 1);
            end if;
            Buffer (I) := Byte;
         end loop;
         if Buffer (1) /= '#' then
            raise Data_Error;
         end if;
      end loop;
   end Get_Line;

   Height : Integer;
   Width  : Integer;
begin
   if Get_Line /= "P6" then
      raise Data_Error;
   end if;
   declare
      Line  : String  := Get_Line;
      Start : Integer := Line'First;
      Last  : Positive;
   begin
      Get (Line, Width, Last);                     Start := Start + Last;
      Get (Line (Start..Line'Last), Height, Last); Start := Start + Last;
      if Start <= Line'Last then
         raise Data_Error;
      end if;
      if Width < 1 or else Height < 1 then
         raise Data_Error;
      end if;
   end;
   if Get_Line /= "255" then
      raise Data_Error;
   end if;
   declare
      Result : Image (1..Height, 1..Width);
      Buffer : String (1..Width * 3);
      Index  : Positive;
   begin
      for I in Result'Range (1) loop
         String'Read (Stream (File), Buffer);
         Index := Buffer'First;
         for J in Result'Range (2) loop
            Result (I, J) :=
               (  R => Luminance (Character'Pos (Buffer (Index))),
                  G => Luminance (Character'Pos (Buffer (Index + 1))),
                  B => Luminance (Character'Pos (Buffer (Index + 2)))
               );
            Index := Index + 3;
         end loop;
      end loop;
      return Result;
   end;
end Get_PPM;
