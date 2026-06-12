program LanternProblem;
uses SysUtils;

// Calculate multinomial coefficient, e.g. input array [3, 6, 4]
//   would give (3 + 6 + 4)! / (3!*6!*4!).
// Result is calculated as a product of binomial coefficients.
function Multinomial( a : array of integer) : UInt64;
var
  n, i, j, k : integer;
  b : array of integer;   // sorted copy of ionput
  row : array of integer; // start of row in Pascal's triangle
begin
  result := 1; // in case of trivial input
  n := Length( a);
  if (n <= 1) then exit;

  // Copy caller's array to local array in descending order
  SetLength( b, n);
  for j := 0 to n - 1 do begin
    k := j;
    while (k > 0) and (b[k - 1] < a[j]) do begin
      b[k] := b[k - 1];  dec(k);
    end;
    b[k] := a[j];
  end;

  // Zero entries don't affect the result, so remove them
  while (n > 0) and (b[n - 1] = 0) do dec(n);
  if (n <= 1) then exit;

  // Non-trivial input, do the calculation by means of Pascal's triangle
  SetLength( row, b[1] + 1);
  row[0] := 1;
  for k := 1 to b[1] do row[k] := 0;
  for i := 1 to b[0] + b[1] do begin
    for k := b[1] downto 1 do inc( row[k], row[k - 1]);
  end;
  result := row[b[1]];  // first binomial coefficient

  // Since b[1] >= b[2] >= b[3] ... there are always enough valid terms
  //   in the row to allow calculation of the next binomial coefficient.
  for j := 2 to n - 1 do begin
    for i := 1 to b[j] do begin
      for k := b[1] downto 1 do inc( row[k], row[k - 1]);
    end;
    result := result*row[b[j]]; // multiply by next binomial coefficient
  end;
end;

// Prompt user for non-negative integer.
// Avoid raising exception when user input isn't an integer.
function UserInt( const prompt : string) : integer;
var
  userInput : string;
  inputOK : boolean;
begin
  repeat
    Write( prompt, ' ');
    ReadLn(userInput);
    inputOK := SysUtils.TryStrToInt( userInput, result) and (result >= 0);
    if not inputOK then WriteLn( 'Try again');
  until inputOK;
end;

// Main routine
var
  nrCols, j : integer;
  counts : array of integer;
begin
  repeat
    nrCols := UserInt( 'Number of columns (0 to quit)?');
    if nrCols = 0 then exit;
    SetLength( counts, nrCols);
    for j := 0 to nrCols - 1 do
      counts[j] := UserInt( SysUtils.Format('How many in column %d?',
                   [j + 1])); // column numbers 1-based for user
    Write( 'Columns are ');
    for j := 0 to nrCols - 1 do Write(' ', counts[j]);
    WriteLn( ',  number of ways = ', Multinomial(counts));
  until false;
end.
