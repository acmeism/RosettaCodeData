program NumberReversalGame;

procedure PrintList(list: array of integer);
var
    i: integer;
begin
    for i := low(list) to high(list) do
    begin
        Write(list[i]);
        if i < high(list) then Write(', ');
    end;
    WriteLn;
end;

procedure Swap(var list: array of integer; i, j: integer);
var
    buf: integer;
begin
    buf := list[i];
    list[i] := list[j];
    list[j] := buf;
end;

procedure ShuffleList(var list: array of integer);
var
    i, j, n: integer;
begin
    Randomize;

    for n := 0 to 99 do
    begin
        i := Random(high(list)+1);
        j := Random(high(list)+1);
        Swap(list, i, j);
    end;
end;

procedure ReverseList(var list: array of integer; j: integer);
var
    i: integer;
begin
    i := low(list);

    while i < j do
    begin
        Swap(list, i, j);
        i += 1;
        j -= 1;
    end;
end;

function IsOrdered(list: array of integer): boolean;
var
    i: integer;
begin
    IsOrdered := true;
    i:= high(list);

    while i > 0 do
    begin
        if list[i] <> (list[i-1] + 1) then
        begin
            IsOrdered:= false;
            break;
        end;
        i -= 1;
    end;
end;


var
    list: array [0..8] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 9);
    n: integer;
    moves: integer;
begin

    WriteLn('Number Reversal Game');
    WriteLn;
    WriteLn('Sort the following list in ascending order by reversing the first n digits');
    WriteLn('from the left.');
    WriteLn;

    ShuffleList(list);
    PrintList(list);

    moves := 0;

    while not IsOrdered(list) do
    begin
        WriteLn('How many digits from the left will you reverse?');
        Write('> ');
        Read(n);

        ReverseList(list, n-1);
        PrintList(list);
        moves += 1;
    end;

    WriteLn;
    WriteLn('Congratulations you made it in just ', moves, ' moves!');
    WriteLn;
end.
