with Ada.Text_IO;

procedure Nested_Functions is -- 'Nested_Functions' is the name of 'main'

   type List is array(Natural range <>) of String(1 .. 10);

   function Make_List(Separator: String) return List is
      Counter: Natural := 0;

      function Make_Item(Item_Name: String) return String is
      begin
	 Counter := Counter + 1; -- local in Make_List, global in Make_Item
	 return(Natural'Image(Counter) & Separator & Item_Name);
      end Make_Item;

   begin
      return (Make_Item("First "), Make_Item("Second"), Make_Item("Third "));
   end Make_List;

begin -- iterate through the result of Make_List
   for Item of Make_List(". ") loop
      Ada.Text_IO.Put_Line(Item);
   end loop;
end Nested_Functions;
