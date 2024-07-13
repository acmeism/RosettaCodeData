program eightqueens(output);
var i: integer;
    a: array [1..8] of boolean; { a[j]: no queen in row j }
    b: array [2..16] of boolean; { b[k]: no queen in kth diagonal down-left }
    c: array [-7..7] of boolean; { c[k]: no queen in kth diagonal down-right }
    x: array [1..8] of integer; { x[i]: position of queen in column i }
procedure print;
    var k: integer;
begin
    for k := 1 to 8 do write(x[k]: 4);
    writeln
end { print } ;

procedure try(i: integer);
    var j: integer;
begin
    for j := 1 to 8 do
        if a[j] and b[i+j] and c[i-j] then
        begin
            { place queen }
            x[i] := j;
            a[j] := false; b[i+j] := false; c[i-j] := false;
            if i < 8 then try(i+1) else print;
            { remove queen }
            a[j] := true; b[i+j] := true; c[i-j] := true
        end
end { try } ;

begin
    for i := 1 to 8 do a[i] := true;
    for i := 2 to 16 do b[i] := true;
    for i := -7 to 7 do c[i] := true;
    try(1)
end .
