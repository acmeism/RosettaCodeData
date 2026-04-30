with Ada.Text_Io; use Ada.Text_Io;

package body Shapes is

   -----------
   -- Print --
   -----------

   procedure Print (Item : in Point) is
   begin
      Put_line("Point");
   end Print;

   ----------
   -- Setx --
   ----------

   function Setx (Item : in Point; Val : Integer) return Point is
   begin
      return (Val, Item.Y);
   end Setx;

   ----------
   -- Sety --
   ----------

   function Sety (Item : in Point; Val : Integer) return Point is
   begin
      return (Item.X, Val);
   end Sety;

   ----------
   -- Getx --
   ----------

   function Getx (Item : in Point) return Integer is
   begin
      return Item.X;
   end Getx;

   ----------
   -- Gety --
   ----------

   function Gety (Item : in Point) return Integer is
   begin
      return Item.Y;
   end Gety;

   ------------
   -- Create --
   ------------

   function Create return Point is
   begin
      return (0, 0);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (X : Integer) return Point is
   begin
      return (X, 0);
   end Create;

   ------------
   -- Create --
   ------------

   function Create (X, Y : Integer) return Point is
   begin
      return (X, Y);
   end Create;

end Shapes;
