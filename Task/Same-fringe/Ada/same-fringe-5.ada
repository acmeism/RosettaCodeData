with Ada.Text_IO, Bin_Trees.Traverse;

procedure Main is

   package B_Trees is new Bin_Trees(Character); use B_Trees;

   function Same_Fringe(T1, T2: Tree_Type) return Boolean is

      protected type Buffer_Type is
         entry Write(Item: Character);
         entry Write_Done;
         entry Read_And_Compare(Item: Character);
         entry Read_Done;
         entry Wait_For_The_End;
         function Early_Abort return Boolean;
         function The_Same return Boolean;
      private
         Current: Character;
         Readable: Boolean := False;
         Done: Boolean := False;
         Same: Boolean := True;
         Finished: Boolean := False;
      end Buffer_Type;

      protected body Buffer_Type is

         entry Write(Item: Character) when not Readable is
         begin
            Readable := True;
            Current  := Item;
         end Write;

         entry Write_Done when not Readable is
         begin
            Readable := True;
            Done     := True;
         end Write_Done;

         entry Read_And_Compare(Item: Character) when Readable is
         begin
            if Done then -- Producer is already out of items
               Same := False;
               Finished := True;
               -- Readable remains True, else Consumer might lock itself out
            elsif
              Item /= Current then
               Same := False;
               Finished := True;
               Readable := False;
            else
                 Readable := False;
            end if;
         end Read_And_Compare;

         entry Read_Done when Readable is
         begin
            Readable := False;
            Same     := Same and Done;
            Finished := True;
         end Read_Done;

         entry Wait_For_The_End when (Finished) or (not Same) is
         begin
            null; -- "when ..." is all we need
         end Wait_For_The_End;

         function The_Same return Boolean is
         begin
            return Same;
         end The_Same;

         function Early_Abort return Boolean is
         begin
            return not The_Same or Finished;
         end Early_Abort;

      end Buffer_Type;

      Buffer: Buffer_Type;

      -- some wrapper subprogram needed to instantiate the generics below

          procedure Prod_Write(Item: Character) is
          begin
             Buffer.Write(Item);
          end Prod_Write;

          function Stop return Boolean is
          begin
             return Buffer.Early_Abort;
          end Stop;

          procedure Prod_Stop is
          begin
             Buffer.Write_Done;
          end Prod_Stop;

          procedure Cons_Write(Item: Character) is
          begin
             Buffer.Read_And_Compare(Item);
          end Cons_Write;

          procedure Cons_Stop is
          begin
             Buffer.Read_Done;
          end Cons_Stop;

      package Producer is new B_Trees.Traverse(Prod_Write, Stop, Prod_Stop);
      package Consumer is new B_Trees.Traverse(Cons_Write, Stop, Cons_Stop);

   begin
      Producer.Inorder_Task.Run(T1);
      Consumer.Inorder_Task.Run(T2);
      Buffer.Wait_For_The_End;
      return Buffer.The_Same;
   end Same_Fringe;

   procedure Show_Preorder(Tree: Tree_Type; Prefix: String := "") is
      use Ada.Text_IO;
   begin
      if Prefix /= "" then
         Ada.Text_IO.Put(Prefix);
      end if;
      if not Empty(Tree) then
         Put("(" & Item(Tree));      Put(", ");
         Show_Preorder(Left(Tree));  Put(", ");
         Show_Preorder(Right(Tree)); Put(")");
      end if;
      if Prefix /= "" then
         New_Line;
      end if;
   end Show_Preorder;

   T_0: Tree_Type := Tree('a', Empty, Tree('b'));
   T: array(1 .. 5) of Tree_Type;

begin
   T(1) := Tree('d', Tree('c'), T_0);
   T(2)  := Tree('c', Empty, Tree('a', Tree('d'), Tree('b')));
   T(3)  := Tree('e', T(1), T(2));
   T(4)  := Tree('e', T(2), T(1));
   T(5)  := Tree('e', T_0, Tree('c', Tree('d'), T(1)));

   -- First display the trees you have (in preorder)
   for I in T'Range loop
      Show_Preorder(T(I), "Tree(" & Integer'Image(I) & " ) is ");
   end loop;
   Ada.Text_IO.New_Line;

   -- Now compare them, which have the same fringe?
   for I in T'Range loop
      for J in T'Range loop
         if Same_Fringe(T(J), T(I)) then
            Ada.Text_IO.Put("same(");
         else
            Ada.Text_IO.Put("DIFF(");
         end if;
         Ada.Text_IO.Put(Integer'Image(I) & "," & Integer'Image(J) & " ); ");
      end loop;
      Ada.Text_IO.New_Line;
   end loop;
end Main;
