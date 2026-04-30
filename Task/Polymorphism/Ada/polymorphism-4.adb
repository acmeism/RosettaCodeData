with Ada.Text_Io; use Ada.Text_IO;

package body Shapes.Circles is

   -----------
   -- Print --
   -----------

   procedure Print (Item : Circle) is
   begin
      Put_line("Circle");
   end Print;

   ----------
   -- Setx --
   ----------

   function Setx (Item : Circle; Val : Integer) return Circle is
   begin
      return (Val, Item.Y, Item.R);
   end Setx;

   ----------
   -- Sety --
   ----------

   function Sety (Item : Circle; Val : Integer) return Circle is
      Temp : Circle := Item;
   begin
      Temp.Y := Val;
      return Temp;
   end Sety;

   ----------
   -- Setr --
   ----------

   function Setr (Item : Circle; Val : Integer) return Circle is
   begin
      return (Item.X, Item.Y, Val);
   end Setr;

   ----------
   -- Getr --
   ----------

   function Getr (Item : Circle) return Integer is
   begin
      return Item.R;
   end Getr;

   ------------
   -- Create --
   ------------

   function Create (P : Point) return Circle is
   begin
      return (P.X, P.Y, 0);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (P : Point; R : Integer) return Circle is
   begin
      return (P.X, P.Y, R);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (X : Integer) return Circle is
   begin
      return (X, 0, 0);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (X : Integer; Y : Integer) return Circle is
   begin
      return (X, Y, 0);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (X : Integer; Y : Integer; R : Integer) return Circle is
   begin
      return (X, Y, R);
   end Create;

   ------------
   -- Create --
   ------------

   function Create return Circle is
   begin
      return (0, 0, 0);
   end Create;

end Shapes.Circles;
