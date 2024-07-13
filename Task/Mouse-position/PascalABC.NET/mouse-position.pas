##
uses GraphWPF;
Font.Size := 80;
OnMouseMove := (x,y,mb) -> begin
  Window.Clear;
  DrawText(Window.ClientRect,$'{x,0:f0}, {y,0:f0}');
end;
