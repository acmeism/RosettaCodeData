const
  ifboth = 0;
  else1 = 1;
  else2 = 2;
  else3 = 3;

function operator **(x, y: boolean): integer; extensionmethod;
begin
  if x and y then result := ifboth
  else
    if x then result := else1
  else
    if y then result := else2
  else result := else3
end;

begin
  case (2 > 1) ** (3 < 2) of
    ifboth: 'both are true'.println;
    else1: 'the first is true'.println;
    else2: 'the second is true'.println;
    else3: 'both are false'.println;
  end;
end.
