with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Integer_Text_IO;      use Ada.Integer_Text_IO;
with Ada.Containers.Generic_Array_Sort;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure Main is
   type map_element is record
      Num  : Positive;
      Word : Unbounded_String;
   end record;

   type map_list is array (Positive range <>) of map_element;

   function "<" (Left, Right : map_element) return Boolean is
   begin
      return Left.Num < Right.Num;
   end "<";

   procedure list_sort is new Ada.Containers.Generic_Array_Sort
     (Index_Type => Positive, Element_Type => map_element,
      Array_Type => map_list);

   procedure general_fizz_buzz (max : Positive; words : in out map_list) is
      found : Boolean;
   begin
      list_sort (words);

      for i in 1 .. max loop
         found := False;
         for element of words loop
            if i mod element.Num = 0 then
               found := True;
               Put (element.Word);
            end if;
         end loop;
         if not found then
            Put (Item => i, Width => 1);
         end if;
         New_Line;
      end loop;
   end general_fizz_buzz;

   fizzy : map_list :=
     ((3, To_Unbounded_String ("FIZZ")), (7, To_Unbounded_String ("BAXX")),
      (5, To_Unbounded_String ("BUZZ")));

begin
   general_fizz_buzz (20, fizzy);
end Main;
