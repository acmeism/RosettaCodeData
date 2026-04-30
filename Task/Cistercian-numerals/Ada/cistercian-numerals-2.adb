--  cistercian.ads
--  representations of Cistercian numbers

package Cistercian is

   type Representation is private;
   --  this type holds the Cistercian representation of a number

   subtype Representable_Range is Natural range 0 .. 9999;
   --  the system only works with values in this range

   function From (Value : Representable_Range) return Representation;
   --  converts `Value` to a `Representation`

   type Quadrant is (Ones, Tens, Hundreds, Thousands);
   --  corresponds to the quadrants used by the system

   type Strokes_Enum is (Diag_From_Far, Diag_From_Near, Far, Near, Side);
   --  corresponds to the line segments:
   --  * Diag_From_Far corresponds to what you'll see in 3, 30, 300, 3000
   --  * Diag_From_Near corresponds to what you'll see in 4, 40, 400, 4000
   --  * Far corresponds to what you'll see in 1, 10, 100, 1000
   --  * Near corresponds to what you'll see in 2, 20, 200, 2000
   --  * Side corresponds to what you'll see in 6, 60, 600, 6000
   --
   --  the others are combinations of these

private

   type Stroke_Used_Array is array (Strokes_Enum) of Boolean;
   --  whether a stroke should be set

   type Representation is array (Quadrant) of Stroke_Used_Array;
   --  indicates which quadrants' strokes are set

end Cistercian;
