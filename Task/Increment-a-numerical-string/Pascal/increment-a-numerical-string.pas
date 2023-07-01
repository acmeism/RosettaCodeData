program TestIncNumString;
type
	tMyNumString = string(20);

procedure IncMyString(var NumString: tMyNumString);
var
	i: integer;
begin
	readStr(NumString, i);
	writeStr(NumString, succ(i))
end;
//example
var
  MyNumString :tMyNumString;
BEGIN
  MyNumString := '12345';
  write(MyNumString,' turns into ');
  IncMyString(MyNumString);
  write(MyNumString);
END.
