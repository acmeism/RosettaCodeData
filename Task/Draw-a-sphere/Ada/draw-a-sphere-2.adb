with Display; use Display;
with Display.Basic; use Display.Basic;

procedure Main is
   Ball : Shape_Id := New_Circle
     (X      => 0.0,
      Y      => 0.0,
      Radius => 20.0,
      Color  => Blue);
begin
   null;
end Main;
