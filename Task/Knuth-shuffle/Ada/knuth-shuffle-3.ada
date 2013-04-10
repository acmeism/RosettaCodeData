with Ada.Text_IO;
with Generic_Shuffle;

procedure Test_Shuffle is

   type Integer_Array is array (Positive range <>) of Integer;

   Integer_List : Integer_Array
     := (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
   procedure Integer_Shuffle is new Generic_Shuffle(Element_Type => Integer,
                                                    Array_Type => Integer_Array);
begin

   for I in Integer_List'Range loop
      Ada.Text_IO.Put(Integer'Image(Integer_List(I)));
   end loop;
   Integer_Shuffle(List => Integer_List);
   Ada.Text_IO.New_Line;
   for I in Integer_List'Range loop
      Ada.Text_IO.Put(Integer'Image(Integer_List(I)));
   end loop;
end Test_Shuffle;
