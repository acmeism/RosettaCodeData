procedure Gnome_Sort(Item : in out Collection) is
   procedure Swap(Left, Right : in out Element_Type) is
      Temp : Element_Type := Left;
   begin
      Left := Right;
      Right := Temp;
   end Swap;

   I : Integer := Index'Pos(Index'Succ(Index'First));
   J : Integer := I + 1;
begin
   while I <= Index'Pos(Index'Last) loop
      if Item(Index'Val(I - 1)) <= Item(Index'Val(I)) then
         I := J;
         J := J + 1;
      else
         Swap(Item(Index'Val(I - 1)), Item(Index'Val(I)));
         I := I - 1;
         if I = Index'Pos(Index'First) then
            I := J;
            J := J + 1;
         end if;
      end if;
   end loop;
end Gnome_Sort;
