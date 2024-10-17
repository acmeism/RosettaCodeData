uses Turtle,GraphWPF;

procedure FractalTree(n: integer; len,angle: real);
begin
  if n = 0 then exit;
  len := len * 0.8;
  Turn(angle);
  Forw(len);
  FractalTree(n-1,len,angle);
  Turn(180);
  Forw(len);
  Turn(180-2*angle);
  Forw(len);
  FractalTree(n-1,len,angle);
  Turn(180);
  Forw(len);
  Turn(180+angle);
end;

begin
  Window.Title := 'Fractal Tree';
  var len := 100;
  var angle := 22;
  ToPoint(400,500);
  Turn(-90);
  Down;
  Forw(100);
  FractalTree(10,len,angle);
end.
