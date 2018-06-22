PROGRAM TwelveStatements;

{
  This program searches through the 4095 possible sets
  of 12 statements for any which may be self-consistent.
}

CONST
    max12b = 4095; { Largest 12 byte number. }

TYPE
    statnum = 1..12;  { statement numbers }
    statset = set of statnum; { sets of statements }

VAR { global variables for use in main algorithm }
    trialNumber: integer;
    trialSet, testResults: statset;

function Convert(n: integer): statset;
{
  Converts an integer into a set of statements.
  For each "1" in the last 12 bits of
  the integer's binary representation,
  a statement number is put into the set.
}
var
    i: statnum;
    s: statset;
begin
    s := []; { Empty set. }
    for i := 12 downto 1 do begin
        if (n mod 2) = 1 then s := s + [i];
        n := n div 2
    end;
    Convert := s
end;

procedure Express(truths: statset);
{
  Writes the statement number of each "truth",
  with at least one space in front,
  all on one line.
}
var n: statnum;
begin
    for n := 1 to 12 do
     if n in truths then write(n:3);
    writeln
end;

function Count(truths: statset): integer;
{ Counts the statement numbers in the set. }
var
    s: statnum;
    i: integer;
begin
    i := 0;
    for s := 1 to 12 do if s in truths then i := i + 1;
    Count := i
end;

function Test(truths: statset): statset;
{
  Starts with a set of supposedly true statements
  and checks which of the 12 statements can actually
  be confirmed about the set itself.
}
var
    evens, odds, confirmations: statset;
begin
    evens := [2, 4, 6, 8, 10, 12];
    odds := [1, 3, 5, 7, 9, 11];

    { Statement 1 is necessarily true. }
    confirmations := [1];

    { Statement 2 }
    if Count(truths * [7..12]) = 3
     then confirmations := confirmations + [2];

    { Statement 3 }
    if Count(truths * evens) = 2
     then confirmations := confirmations + [3];

    { Statement 4 is true if 6 and 7 are true, or if 5 is false. }
    if ([6, 7] <= truths) or not (5 in truths)
     then confirmations := confirmations + [4];

    { Statement 5 }
    if [2, 3, 4] <= truths
     then confirmations := confirmations + [5];

    { Statement 6 }
    if Count(truths * odds) = 4
     then confirmations := confirmations + [6];

    { Statement 7 }
    if (2 in truths) xor (3 in truths)
     then confirmations := confirmations + [7];

    { Statement 8 is true if 5 and 6 are true, or if 7 is false. }
    if ([5, 6] <= truths) or not (7 in truths)
     then confirmations := confirmations + [8];

    { Statement 9 }
    if Count(truths * [1..6]) = 3
     then confirmations := confirmations + [9];

    { Statement 10 }
    if [11, 12] <= truths
     then confirmations := confirmations + [10];

    { Statement 11 }
    if Count(truths * [7, 8, 9]) = 1
     then confirmations := confirmations + [11];

    { Statement 12 }
    if Count(truths - [12]) = 4
     then confirmations := confirmations + [12];

    Test := confirmations
end;

BEGIN  { Main algorithm. }
    for trialNumber := 1 to max12b do begin
        trialSet := Convert(trialNumber);
        testResults := Test(trialSet);
        if testResults = trialSet then Express(trialSet)
    end;
    writeln('Done. Press ENTER.');
    readln
END.
