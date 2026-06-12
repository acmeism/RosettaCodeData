with ada.float_text_io; use ada.float_text_io; -- for put()
with ada.numerics; use ada.numerics;           -- for pi
with ada.text_io; use ada.text_io;             -- for new_line

procedure arc_length_both is
   type Degree is new Float;
   type Radian is new Float;

   function arc_length(radius: Float; deg1, deg2: Degree) return Float is
      ((360.0 - abs(Float(deg1) - Float(deg2))) * radius * pi / 180.0);

   function arc_length(radius: Float; rad1, rad2: Radian) return Float is
      ((2.0 * pi - abs(Float(rad1) - Float(rad2))) * radius);

  d1 : Degree := 120.0;
  d2 : Degree :=  10.0;
  r1 : Radian := Radian(d1) * pi / 180.0;
  r2 : Radian := Radian(d2) * pi / 180.0;
begin
   put(arc_length(10.0, d1, d2), fore=>0, aft=>15, exp=>0);
   new_line;
   put(arc_length(10.0, r1, r2), fore=>0, aft=>15, exp=>0);
   new_line;
   -- Next line will not compile as you cannot mix Degree and Radian
   -- put(arc_length(10.0, d1, r2), fore=>0, aft=>15, exp=>0);
end arc_length_both;
