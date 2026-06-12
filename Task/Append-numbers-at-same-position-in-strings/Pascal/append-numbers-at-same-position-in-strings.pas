program appendNumbersAtSamePositionInStrings(output);

type
    wholeNumber = 0..maxInt;

var
    i: integer;
    { Indices were chosen to ease up initialization in main block. }
    list0: array[1..9] of wholeNumber;
    list1: array[10..18] of wholeNumber;
    list2: array[19..27] of wholeNumber;

{ Returns the number of digits necessary to express as decimal. }
function digitCount(i: wholeNumber): wholeNumber;
begin
    { Instead of an `if` branch you can simply write: }
    i := i + ord(i = 0);
    { Remember: Argument to `ln` must be positive. }
    digitCount := succ(trunc(ln(i) / ln(10)))
end;

{ Appends two list members in place. }
procedure append(
        { DI: Destination Index; SI: Source Index. }
        var destination: array[diMin..diMax: integer] of wholeNumber;
        source: array[siMin..siMax: integer] of wholeNumber
    );
var
    i, n: integer;
begin
    { Determine maximum index range. }
    i := diMax - diMin;
    if (siMax - siMin) < i then
    begin
        i := siMax - siMin
    end;

    { NB: In Pascal `for`-loop-limits are evaluation exactly once only. }
    for i := 0 to i do
    begin
        { In Extended Pascal (ISO 10206) you could actually simply write: }
        { … := destination[diMin + i] * 10 pow digitCount(source[siMin + i]) }
        for n := 1 to digitCount(source[siMin + i]) do
        begin
            destination[diMin + i] := destination[diMin + i] * 10
        end;
        destination[diMin + i] := destination[diMin + i] + source[siMin + i]
    end
end;

{ Calls `append` twice. }
procedure appendTwo(
        var destination: array[diMin..diMax: integer] of wholeNumber;
        source0: array[si0Min..si0Max: integer] of wholeNumber;
        source1: array[si1Min..si1Max: integer] of wholeNumber
    );
begin
    append(destination, source0);
    append(destination, source1)
end;

{ === MAIN ============================================================= }
begin
    for i := 1 to 9 do
    begin
        list0[i] := i
    end;
    for i := 10 to 18 do
    begin
        list1[i] := i
    end;
    for i := 19 to 27 do
    begin
        list2[i] := i
    end;

    appendTwo(list0, list1, list2);

    for i := 1 to 9 do
    begin
        writeLn(list0[i])
    end
end.
