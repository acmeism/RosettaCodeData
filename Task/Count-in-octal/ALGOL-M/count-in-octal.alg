begin

% display n on console in octal format %
procedure putoct(n);
integer n;
begin
  integer digit, n8;
  string(1) array octdig[0:7];
  octdig[0] := "0"; octdig[1] := "1"; octdig[2] := "2";
  octdig[3] := "3"; octdig[4] := "4"; octdig[5] := "5";
  octdig[6] := "6"; octdig[7] := "7";
  n8 := n / 8;
  if n8 <> 0 then putoct(n8); % recursive call %
  digit := n - (n / 8) * 8;   % n mod 8 %
  writeon(octdig[digit]);
end;

integer i, maxint;
i := 1;
maxint := 16383;

comment
  Excercise the procedure by counting up in octal as
  far as possible. In doing so, we have to take some
  care, because integer variables are set to 1 on
  overflow, and if that happens, the loop will simply
  start over, and the program will run forever;

while i < maxint do  % we need to stop one shy %
  begin
    write("");
    putoct(i);
    i := i + 1;
  end;

% display the final value %
write("");
putoct(maxint);

end
