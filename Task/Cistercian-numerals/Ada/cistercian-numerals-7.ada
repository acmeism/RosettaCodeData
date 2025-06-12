--  cistercian-ascii.adb

pragma Ada_2022;

with Ada.Text_IO;

with Cistercian.Motion;

package body Cistercian.Ascii is

   package IO renames Ada.Text_IO;
   package CM renames Cistercian.Motion;

   function From (Value : Cistercian.Representation) return Block is
      --  converts the representation to an ASCII block

      Result : Block := Zero;

      --  the extreme values for rows and columns,
      --  as determine by where you want to start and which quadrant you're in

      Row_Extremes :
        constant array (CM.Start_Enum, Quadrant) of Cistercian_Ascii_Range :=
          [CM.Far  => [Ones | Tens => -Max, Hundreds | Thousands => Max],
           CM.Near => [Ones | Tens => -1, Hundreds | Thousands => 1]];
      Col_Extremes :
        constant array (CM.Start_Enum, Quadrant) of Cistercian_Ascii_Range :=
          [CM.Far  => [Ones | Hundreds => Max, Tens | Thousands => -Max],
           CM.Near => [Ones | Hundreds => 1, Tens | Thousands => -1]];

      Row_Pos, Col_Pos     : Cistercian_Ascii_Range;
      Row_Delta, Col_Delta : CM.Motion_Delta;

   begin

      for Place in Quadrant loop
         for Stroke in Cistercian.Strokes_Enum when Value (Place) (Stroke) loop

            --  obtain position and motion information
            Row_Pos :=
              Row_Extremes
                (CM.Stroke_Arrangement (Place, Stroke).Row_Start, Place);
            Col_Pos :=
              Col_Extremes
                (CM.Stroke_Arrangement (Place, Stroke).Col_Start, Place);
            Row_Delta := CM.Stroke_Arrangement (Place, Stroke).Row_Delta;
            Col_Delta := CM.Stroke_Arrangement (Place, Stroke).Col_Delta;

            --  make the stroke
            for Ith in 1 .. Max loop
               Result (Row_Pos, Col_Pos) := True;
               Row_Pos := @ + Row_Delta;
               Col_Pos := @ + Col_Delta;
            end loop;

         end loop;
      end loop;

      return Result;

   end From;

   procedure Put (Value : Cistercian.Representation) is
      --  writes Value to standard output
      X_At : constant Block := From (Value);
   begin

      for Row in X_At'Range (1) loop
         for Col in X_At'Range (2) loop
            IO.Put ((if X_At (Row, Col) then 'X' else ' '));
         end loop;
         IO.New_Line;
      end loop;
   end Put;

end Cistercian.Ascii;
