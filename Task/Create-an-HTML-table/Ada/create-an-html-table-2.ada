package body HTML_Table is

   procedure Print(Items: Item_Array; Column_Heads: Header_Array) is

      function Blanks(N: Natural) return String is
         -- indention for better readable HTML
      begin
         if N=0 then
            return "";
         else
            return " " & Blanks(N-1);
         end if;
      end Blanks;

      procedure Print_Row(Row_Number: Positive) is
      begin
         Put(Blanks(4) & "<tr><td>" & Positive'Image(Row_Number) & "</td>");
         for I in Items'Range(2) loop
            Put("<td>" & To_String(Items(Row_Number, I)) & "</td>");
                end loop;
            Put_Line("</tr>");
      end Print_Row;

      procedure Print_Body is
      begin
         Put_Line(Blanks(2)&"<tbody align = ""right"">");
         for I in Items'Range(1) loop
            Print_Row(I);
         end loop;
         Put_Line(Blanks(2)&"</tbody>");
      end Print_Body;

      procedure Print_Header is
         function To_Str(U: U_String) return String renames
           Ada.Strings.Unbounded.To_String;
      begin
         Put_Line(Blanks(2) & "<thead align = ""right"">");
         Put(Blanks(4) & "<tr><th></th>");
         for I in Column_Heads'Range loop
            Put("<td>" & To_Str(Column_Heads(I)) & "</td>");
         end loop;
         Put_Line("</tr>");
         Put_Line(Blanks(2) & "</thead>");
      end Print_Header;

   begin
      if Items'Length(2) /= Column_Heads'Length then
         raise Constraint_Error with "number of headers /= number of columns";
      end if;
      Put_Line("<table>");
      Print_Header;
      Print_Body;
      Put_Line("</table>");
   end Print;

end HTML_Table;
