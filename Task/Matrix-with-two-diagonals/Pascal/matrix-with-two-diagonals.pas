program diagonaldiagonal;
const N = 7;
type
    index = 1..N;
var
    a : array[index, index] of real;
    i, j, j1, j2 : index;
begin
    for i := 1 to N do
    begin
        for j := 1 to N do
            a[i, j] := 0.0;
        j1 := i;
        j2 := N - i + 1;
        a[i, j1] := 1.0;
        a[i, j2] := 1.0;
    end;

    for i := 1 to N do
    begin
        for j := 1 to N do
            write(a[i, j]:2:0);
        writeln();
    end
end.
