procedure Flood_Fill
          (  Picture  : in out Image;
             From     : Point;
             Fill     : Pixel;
             Replace  : Pixel;
             Distance : Luminance := 20
          )  is
   function Diff (A, B : Luminance) return Luminance is
      pragma Inline (Diff);
   begin
      if A > B then
         return A - B;
      else
         return B - A;
      end if;
   end Diff;

   function "-" (A, B : Pixel) return Luminance is
      pragma Inline ("-");
   begin
      return Luminance'Max (Luminance'Max (Diff (A.R, B.R), Diff (A.G, B.G)), Diff (A.B, B.B));
   end "-";
   procedure Column (From : Point);
   procedure Row (From : Point);

   Visited : array (Picture'Range (1), Picture'Range (2)) of Boolean :=
      (others => (others => False));

   procedure Column (From : Point) is
      X1 : Positive := From.X;
      X2 : Positive := From.X;
   begin
      Visited (From.X, From.Y) := True;
      for X in reverse Picture'First (1)..From.X - 1 loop
         exit when Visited (X, From.Y);
         declare
            Color : Pixel renames Picture (X, From.Y);
         begin
            Visited (X, From.Y) := True;
            exit when Color - Replace > Distance;
            Color := Fill;
            X1    := X;
         end;
      end loop;
      for X in From.X + 1..Picture'Last (1) loop
         exit when Visited (X, From.Y);
         declare
            Color : Pixel renames Picture (X, From.Y);
         begin
            Visited (X, From.Y) := True;
            exit when Color - Replace > Distance;
            Color := Fill;
            X2    := X;
         end;
      end loop;
      for X in X1..From.X - 1 loop
         Row ((X, From.Y));
      end loop;
      for X in From.X + 1..X2 loop
         Row ((X, From.Y));
      end loop;
   end Column;

   procedure Row (From : Point) is
      Y1 : Positive := From.Y;
      Y2 : Positive := From.Y;
   begin
      Visited (From.X, From.Y) := True;
      for Y in reverse Picture'First (2)..From.Y - 1 loop
         exit when Visited (From.X, Y);
         declare
            Color : Pixel renames Picture (From.X, Y);
         begin
            Visited (From.X, Y) := True;
            exit when Color - Replace > Distance;
            Color := Fill;
            Y1    := Y;
         end;
      end loop;
      for Y in From.Y + 1..Picture'Last (2) loop
         exit when Visited (From.X, Y);
         declare
            Color : Pixel renames Picture (From.X, Y);
         begin
            Visited (From.X, Y) := True;
            exit when Color - Replace > Distance;
            Color := Fill;
            Y2    := Y;
         end;
      end loop;
      for Y in Y1..From.Y - 1 loop
         Column ((From.X, Y));
      end loop;
      for Y in From.Y + 1..Y2 loop
         Column ((From.X, Y));
      end loop;
   end Row;

   Color : Pixel renames Picture (From.X, From.Y);
begin
   if Color - Replace <= Distance then
      Visited (From.X, From.Y) := True;
      Color := Fill;
      Column (From);
   end if;
end Flood_Fill;
