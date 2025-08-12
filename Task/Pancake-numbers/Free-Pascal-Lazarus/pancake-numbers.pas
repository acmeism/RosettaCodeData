program pc;

function pancake(n:integer):integer;
var
  gap, sum, adj:integer;
begin
  gap := 2;
  sum := 2;
  adj := -1;
  while sum < n do
  begin
    inc(adj);
    gap := gap*2 - 1;
    sum := sum + gap;
  end;
  pancake := n + adj;
end;

var
  i,j,n:integer;
begin
    for i := 0 to 3 do
    begin
        for j := 1 to 5 do
        begin
            n := i*5 + j;
            writeln('p',n:2,pancake(n):5);
        end;
        writeln;
    end
end.
