program CWTerms;

{-------------------------------------------------------------------------------
FreePascal command-line program.
Calculates the Calkin-Wilf sequence up to the specified maximum index,
  where the first term 1/1 has index 1.
Command line format is: CWTerms <max_index>

The program demonstrates 3 algorithms for calculating the sequence:
(1) Calculate term[2n] and term[2n + 1] from term[n]
(2) Calculate term[n + 1] from term[n]
(3) Calculate term[n] directly from n, without using other terms
Algorithm 1 is called first, and stores the terms in an array.
Then the program calls Algorithms 2 and 3, and checks that they agree
  with Algorithm 1.
-------------------------------------------------------------------------------}

uses SysUtils;

type TRational = record
  Num, Den : integer;
end;

var
  terms : array of TRational;
  max_index, k : integer;

  // Routine to calculate array of terms up the the maiximum index
  procedure CalcTerms_algo_1();
  var
    j, k : integer;
  begin
    SetLength( terms, max_index + 1);
    j := 1; // index to earlier term, from which current term is calculated
    k := 1; // index to current term
    terms[1].Num := 1;
    terms[1].Den := 1;
    while (k < max_index) do begin
      inc(k);
      if (k and 1) = 0 then begin // or could write "if not Odd(k)"
        terms[k].Num := terms[j].Num;
        terms[k].Den := terms[j].Num + terms[j].Den;
      end
      else begin
        terms[k].Num := terms[j].Num + terms[j].Den;
        terms[k].Den := terms[j].Den;
        inc(j);
      end;
    end;
  end;

  // Method to get each term from the preceding term.
  // a/b --> b/(a + b - 2(a mod b));
  function CheckTerms_algo_2() : boolean;
  var
    index, a, b, temp : integer;
  begin
    result := true;
    index := 1;
    a := 1;
    b := 1;
    while (index <= max_index) do begin
      if (a <> terms[index].Num) or (b <> terms[index].Den) then
        result := false;
      temp := a + b - 2*(a mod b);
      a := b;
      b := temp;
      inc( index)
    end;
  end;

  // Mathod to calcualte each term from its index, without using other terms.
  function CheckTerms_algo_3() : boolean;
  var
    index, a, b, pwr2, idiv2 : integer;
  begin
    result := true;
    for index := 1 to max_index do begin

      idiv2 := index div 2;
      pwr2 := 1;
      while (pwr2 <= idiv2) do pwr2 := pwr2 shl 1;
      a := 1;
      b := 1;
      while (pwr2 > 1) do begin
        pwr2 := pwr2 shr 1;
        if (pwr2 and index) = 0 then
          inc( b, a)
        else
          inc( a, b);
      end;
      if (a <> terms[index].Num) or (b <> terms[index].Den) then
        result := false;
    end;
  end;

begin
  // Read and validate maximum index
  max_index := SysUtils.StrToIntDef( paramStr(1), -1); // -1 if not an integer
  if (max_index <= 0) then begin
    WriteLn( 'Maximum index must be a positive integer');
    exit;
  end;

  // Calculate terms by algo 1, then check that algos 2 and 3 agree.
  CalcTerms_algo_1();
  if not CheckTerms_algo_2() then begin
    WriteLn( 'Algorithm 2 failed');
    exit;
  end;
  if not CheckTerms_algo_3() then begin
    WriteLn( 'Algorithm 3 failed');
    exit;
  end;

  // Display the terms
  for k := 1 to max_index do
    with terms[k] do
      WriteLn( SysUtils.Format( '%8d: %d/%d', [k, Num, Den]));
end.
