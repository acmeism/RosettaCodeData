with Ada.Text_IO;                              use Ada.Text_IO;
with Ada.Strings.Fixed.Equal_Case_Insensitive; use Ada.Strings.Fixed;
with Ada.Strings.Bounded;

procedure Main is

   package B_String is new Ada.Strings.Bounded.Generic_Bounded_Length (30);
   use B_String;
   function is_equal (left, right : String) return Boolean renames
     Ada.Strings.Fixed.Equal_Case_Insensitive;

   type extension_list is array (Positive range <>) of Bounded_String;
   Ext_List : extension_list :=
     (To_Bounded_String ("zip"), To_Bounded_String ("rar"),
      To_Bounded_String ("7z"), To_Bounded_String ("gz"),
      To_Bounded_String ("archive"), To_Bounded_String ("A##"),
      To_Bounded_String ("tar.bz2"));
   type filename_list is array (Positive range <>) of Bounded_String;
   fnames : filename_list :=
     (To_Bounded_String ("MyData.a##"), To_Bounded_String ("MyData.tar.Gz"),
      To_Bounded_String ("MyData.gzip"), To_Bounded_String ("MyData..."),
      To_Bounded_String ("Mydata"), To_Bounded_String ("MyData_V1.0.tar.bz2"),
      To_Bounded_String ("MyData_v1.0.bz2"));
   Valid_Extension : Boolean;
begin
   for name of fnames loop
      Valid_Extension := False;
      Put (To_String (name));
      for ext of Ext_List loop
         declare
            S : String := "." & To_String (ext);
            T : String := Tail (Source => To_String (name), Count => S'Length);
         begin
            if is_equal (S, T) then
               Valid_Extension := True;
            end if;
         end;
      end loop;
      Set_Col (22);
      Put_Line (": " & Valid_Extension'Image);
   end loop;
end Main;
