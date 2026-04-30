with Ada.Strings.Fixed, Ada.Text_IO;

package body String_Helper is

   function Index(Source: String; Pattern: String) return Natural is
   begin
      return Ada.Strings.Fixed.Index(Source => Source, Pattern => Pattern);
   end Index;

   procedure Search_Brackets(Source: String;
                             Left_Bracket: String;
                             Right_Bracket: String;
                             First, Last: out Natural) is
   begin
      First := Index(Source, Left_Bracket);
      if First = 0 then
         Last := 0; -- not found
      else
         Last := Index(Source(First+1 .. Source'Last), Right_Bracket);
         if Last = 0 then
            First := 0; -- not found;
         end if;
      end if;
   end Search_Brackets;

   function Replace(Source: String; Old_Word: String; New_Word: String)
                   return String is
      L: Positive := Old_Word'Length;
      I: Natural := Index(Source, Old_Word);
   begin
      if I = 0 then
         return Source;
      else
         return Source(Source'First .. I-1) & New_Word
           & Replace(Source(I+L .. Source'Last), Old_Word, New_Word);
      end if;
   end Replace;

   function Get_Vector(Filename: String) return Vector is
      F: Ada.Text_IO.File_Type;
      T: Vector;
   begin
      Ada.Text_IO.Open(F, Ada.Text_IO.In_File, Filename);
      while not Ada.Text_IO.End_Of_File(F) loop
         T.Append(Ada.Text_IO.Get_Line(F));
      end loop;
      Ada.Text_IO.Close(F);
      return T;
   end Get_Vector;

end String_Helper;
