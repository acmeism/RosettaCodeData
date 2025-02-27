##
function lcs(s1, s2: string): String;
begin
  var l := 1;
  var r := 0;
  var sub_len := 0;
  for var i := 1 to s1.length do
    foreach var j in (i..s1.length) do
    begin
      if s2.contains(s1[i:j + 1]) then
        if sub_len <= j - i then
        begin
          (l, r) := (i, j);
          sub_len := j - i;
        end
        else break
    end;
  result := s1[l:r + 1];
end;

lcs('thisisatest', 'testing123testing').println;
