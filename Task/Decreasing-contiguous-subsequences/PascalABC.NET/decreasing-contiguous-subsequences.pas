// Decreasing contiguous subsequences. Nigel Galloway: September 11th., 2024
var f: file of integer;
type Tcat=(LT4,LT8,LT12,LT25,GT25);
function cat(n:integer;g:integer):Tcat;
begin
  var t:=100-(g/n)*100;
  Result:=if t<4.0 then LT4 else if t<8.0 then LT8 else if t<12.0 then LT12 else if t<25.0 then LT25 else GT25;
end;
function fN(f:file of integer;n:integer;g:integer):sequence of Tcat;
begin
  if not eof(f) then begin
    var t:= f.read;
    if t<=g then begin yield sequence fN(f,n,t); exit; end;
    if n>g then yield cat(n,g);
    yield sequence fN(f,t,t);
    exit;
  end;
  if n>g then yield cat(n,g);
end;
begin
  assign(f,'test.dat');
  reset(f);
  var t:=f.read;
  print(fN(f,t,t).eachCount);
  close(f);
end.
