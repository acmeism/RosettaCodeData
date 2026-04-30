with Ada.Text_IO;
with Nestable_Lists;

procedure Flatten_A_List is
   package Int_List is new Nestable_Lists
     (Element_Type => Integer,
      To_String    => Integer'Image);

   List : Int_List.List := null;
begin
   Int_List.Append (List, Int_List.New_List (1));
   Int_List.Append (List, 2);
   Int_List.Append (List, Int_List.New_List (Int_List.New_List (3)));
   Int_List.Append (List.Next.Next.Sublist.Sublist, 4);
   Int_List.Append (List.Next.Next.Sublist, 5);
   Int_List.Append (List, Int_List.New_List (Int_List.New_List (null)));
   Int_List.Append (List, Int_List.New_List (Int_List.New_List
                    (Int_List.New_List (6))));
   Int_List.Append (List, 7);
   Int_List.Append (List, 8);
   Int_List.Append (List, null);

   declare
      Flattened : constant Int_List.List := Int_List.Flatten (List);
   begin
      Ada.Text_IO.Put_Line (Int_List.To_String (List));
      Ada.Text_IO.Put_Line (Int_List.To_String (Flattened));
   end;
end Flatten_A_List;
