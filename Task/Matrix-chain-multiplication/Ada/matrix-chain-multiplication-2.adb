with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body mat_chain is
   type Result_Matrix is
     array (Positive range <>, Positive range <>) of Integer;

   --------------------------
   -- Chain_Multiplication --
   --------------------------

   procedure Chain_Multiplication (Dims : Vector) is
      n : Natural := Dims'Length - 1;
      S : Result_Matrix (1 .. n, 1 .. n);
      m : Result_Matrix (1 .. n, 1 .. n);
      procedure Print (Item : Vector) is
      begin
         Put ("Array Dimension  = (");
         for I in Item'Range loop
            Put (Item (I)'Image);
            if I < Item'Last then
               Put (",");
            else
               Put (")");
            end if;
         end loop;
         New_Line;
      end Print;

      procedure Chain_Order (Item : Vector) is
         J    : Natural;
         Cost : Natural;
         Temp : Natural;

      begin
         for idx in 1 .. n loop
            m (idx, idx) := 0;
         end loop;

         for Len in 2 .. n loop
            for I in 1 .. n - Len + 1 loop
               J        := I + Len - 1;
               m (I, J) := Integer'Last;
               for K in I .. J - 1 loop
                  Temp := Item (I - 1) * Item (K) * Item (J);
                  Cost := m (I, K) + m (K + 1, J) + Temp;
                  if Cost < m (I, J) then
                     m (I, J) := Cost;
                     S (I, J) := K;
                  end if;
               end loop;
            end loop;
         end loop;
      end Chain_Order;

      function Optimal_Parens return String is
         function Construct
           (S : Result_Matrix; I : Natural; J : Natural)
            return Unbounded_String
         is
            Us         : Unbounded_String := Null_Unbounded_String;
            Char_Order : Character;
         begin
            if I = J then
               Char_Order := Character'Val (I + 64);
               Append (Source => Us, New_Item => Char_Order);
               return Us;
            else
               Append (Source => Us, New_Item => '(');
               Append (Source => Us, New_Item => Construct (S, I, S (I, J)));
               Append (Source => Us, New_Item => '*');
               Append
                 (Source => Us, New_Item => Construct (S, S (I, J) + 1, J));
               Append (Source => Us, New_Item => ')');
               return Us;
            end if;
         end Construct;

      begin
         return To_String (Construct (S, 1, n));

      end Optimal_Parens;

   begin
      Chain_Order (Dims);
      Print (Dims);
      Put_Line ("Cost             = " & Integer'Image (m (1, n)));
      Put_Line ("Optimal Multiply = " & Optimal_Parens);
   end Chain_Multiplication;

end mat_chain;
