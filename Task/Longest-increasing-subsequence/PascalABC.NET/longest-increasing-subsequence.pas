function lis(list: array of integer): sequence of array of integer;
begin
  for var len := list.Count downto 1 do
  begin
    var res := new integer[len];
    foreach var sub in (0..list.Count - 1).Combinations(len) do
    begin
      var temp := list[sub[0]];
      for var ind := 1 to len - 1 do
        if list[sub[ind]] > temp then
        begin
          temp := list[sub[ind]];
          if ind = len - 1 then
          begin
            foreach var n in sub index i do
              res[i] := (list[n]);
            yield res;
          end;
        end
        else break;
    end;
  end;
end;

begin
var a := |3, 2, 6, 4, 5, 1|;
lis(a).First.Println;
a := |0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15|;
lis(a).First.Println;
end.
