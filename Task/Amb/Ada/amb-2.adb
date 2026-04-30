-- MacOS, GNAT, gnat-aarch64-darwin-15.1.0-2
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO;            use Ada.Text_IO;

procedure Test_Amb is
   type Alternatives is array (Positive range <>) of Unbounded_String;

   type Amb (Count : Positive) is record
      This : Positive := 1;
      Left : access Amb;
      List : Alternatives (1..Count);
   end record;

   function "/" (L, R : String) return Amb;
   function "/" (L : Amb; R : String) return Amb;
   function "=" (L, R : Amb) return Boolean;
   function Image (L : Amb) return String;
   procedure Join (L : access Amb; R : in out Amb);
   procedure Failure (L : in out Amb);

   function Image (L : Amb) return String is
   begin
      return To_String (L.List (L.This));
   end Image;

   function "/" (L, R : String) return Amb is
      Result : Amb (2);
   begin
      Append (Result.List (1), L);
      Append (Result.List (2), R);
      return Result;
   end "/";

   function "/" (L : Amb; R : String) return Amb is
      Result : Amb (L.Count + 1);
   begin
      Result.List (1..L.Count) := L.List ;
      Append (Result.List (Result.Count), R);
      return Result;
   end "/";

   function "=" (L, R : Amb) return Boolean is
      Left : Unbounded_String renames L.List (L.This);
   begin
      return Element (Left, Length (Left)) = Element (R.List (R.This), 1);
   end "=";

   procedure Failure (L : in out Amb) is
   begin
      loop
         if L.This < L.Count then
            L.This := L.This + 1;
         else
            L.This := 1;
            Failure (L.Left.all);
         end if;
         exit when L.Left = null or else L.Left.all = L;
      end loop;
   end Failure;

   procedure Join (L : access Amb; R : in out Amb) is
   begin
      R.Left := L;
      while L.all /= R loop
         Failure (R);
      end loop;
   end Join;

   W_1 : aliased Amb := "the" / "that" / "a";
   W_2 : aliased Amb := "frog" / "elephant" / "thing";
   W_3 : aliased Amb := "walked" / "treaded" / "grows";
   W_4 : aliased Amb := "slowly" / "quickly";
begin
   Join (W_1'Access, W_2);
   Join (W_2'Access, W_3);
   Join (W_3'Access, W_4);
   Put_Line (Image (W_1) & ' ' & Image (W_2) & ' ' & Image (W_3) & ' ' & Image (W_4));
end Test_Amb;
