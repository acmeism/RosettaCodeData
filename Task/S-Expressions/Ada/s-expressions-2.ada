with Ada.Integer_Text_IO, Ada.Float_Text_IO;

package body S_Expr is

   function First(This: List_Of_Data) return Data is
   begin
      return This.Values.First_Element;
   end First;

   function Rest(This: List_Of_Data) return List_Of_Data is
      List: List_Of_Data := This;
   begin
      List.Values.Delete_First;
      return List;
   end Rest;

   function Empty(This: List_Of_Data) return Boolean is
   begin
      return This.Values.Is_Empty;
   end Empty;

   procedure Print(This: Empty_Data; Indention: Natural) is
   begin
      Print_Line(Indention, "");
   end Print;

   procedure Print(This: Int_Data; Indention: Natural) is
   begin
      Print_Line(Indention, Integer'Image(This.Value));
   end Print;

   procedure Print(This: Flt_Data; Indention: Natural) is
   begin
      Print_Line(Indention, Float'Image(This.Value));
   end Print;

   procedure Print(This: Str_Data; Indention: Natural) is
   begin
      if This.Quoted then
         Print_Line(Indention, """" & (+This.Value) & """");
      else
         Print_Line(Indention, +This.Value);
      end if;
   end Print;

   procedure Print(This: List_Of_Data; Indention: Natural) is
   begin
      Print_Line(Indention, " ( ");
      for I in This.Values.First_Index .. This.Values.Last_Index loop
         This.Values.Element(I).Print(Indention + 1);
      end loop;
      Print_Line(Indention, " ) ");
   end Print;

end S_Expr;
