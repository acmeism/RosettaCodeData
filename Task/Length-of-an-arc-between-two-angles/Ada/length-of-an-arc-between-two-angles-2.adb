with ada.float_text_io; use ada.float_text_io; -- for put()
with ada.numerics; use ada.numerics;           -- for pi
with ada.text_io; use ada.text_io;             -- for new_line

procedure arc_length_simple is

   function arc_length(radius, deg1, deg2: Float) return Float is
      ((360.0 - abs(deg1 - deg2)) * pi * radius / 180.0);

begin
   put(arc_length(10.0, 120.0, 10.0), fore=>0, aft=>15, exp=>0);
   new_line;
end arc_length_simple;
