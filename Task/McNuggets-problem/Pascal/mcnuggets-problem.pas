program McNuggets;

{$mode objfpc}{$H+}

const
  ARRAY_SIZE_STEP = 20; // small, to demonstrate extending array dynamically
var
  i, nr_consec : integer;
  can_do : array of boolean;
begin
  SetLength( can_do, ARRAY_SIZE_STEP);
  can_do[0] := true;
  nr_consec := 0;
  i := 0;
  repeat
    inc(i);
    if i >= Length( can_do) then SetLength( can_do, i + ARRAY_SIZE_STEP);
    can_do[i] := ((i >= 6) and can_do[i - 6])
              or ((i >= 9) and can_do[i - 9])
              or ((i >= 20) and can_do[i - 20]);
    if can_do[i] then begin
      if can_do[i - 1] then inc( nr_consec)
      else nr_consec := 1;
    end
    else nr_consec := 0;
  until nr_consec = 6;
  WriteLn ('Max that can''t be represented is ', i - 6);
end.
