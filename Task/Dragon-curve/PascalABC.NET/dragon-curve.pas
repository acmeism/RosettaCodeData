uses Turtle;

var
  Atom,FStr,XStr,YStr: string;
  angle,len,x0,y0: real;
  n: integer;

procedure Init1; // Dragon
begin
  (Atom,FStr,XStr,YStr) := ('fx','f','x+yf+','-fx-y');
  (angle,len,n,x0,y0) := (90,3,15,300,450);
end;

procedure RunStr(s: string; n: integer);
begin
  foreach var c in s do
    case c of
      '+': Turn(angle);
      '-': Turn(-angle);
      'f','F': if n>0 then RunStr(FStr,n-1) else Forw(len);
      'x','X': if n>0 then RunStr(XStr,n-1);
      'y','Y': if n>0 then RunStr(YStr,n-1);
      else Print('error')
    end;
end;

begin
  Init1;
  ToPoint(x0,y0);
  SetWidth(0.5);
  Down;
  RunStr(Atom,n);
  Up;
end.
