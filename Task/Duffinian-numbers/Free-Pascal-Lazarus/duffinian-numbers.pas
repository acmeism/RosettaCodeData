program DuffinianNumbers;

CONST
  MaxSigma = 10000;

VAR
    seen, cur: CARDINAL;
    sigma: ARRAY [1..MaxSigma] OF CARDINAL;

PROCEDURE CalculateSigmaTable;
    VAR i, j: CARDINAL;
BEGIN
  FOR i := 1 TO MaxSigma DO
  BEGIN
    sigma[i] := 0
  END;
  FOR i := 1 TO MaxSigma DO
  BEGIN
    j := i;//2*i -> sigma(n)-n
    WHILE j <= MaxSigma DO
    Begin
      INC(sigma[j], i);
      INC(j, i);
    END
  END
END;// CalculateSigmaTable;

FUNCTION GCD(a, b: CARDINAL): CARDINAL;
VAR c: CARDINAL;
BEGIN
  WHILE b <>0 DO
  Begin
    c := a MOD b;
    a := b;
    b := c
  END;
  EXIT(A)
END;// GCD;

function IsDuffinian(n: CARDINAL): BOOLEAN;
BEGIN
  EXIT( (sigma[n] > n+1) AND (GCD(n, sigma[n]) = 1))
END;// IsDuffinian;

FUNCTION IsDuffinianTriple(n: CARDINAL): BOOLEAN;
BEGIN
  EXIT(IsDuffinian(n) AND IsDuffinian(n+1) AND IsDuffinian(n+2));
END;// IsDuffinianTriple;

BEGIN
  CalculateSigmaTable;
  Writeln('First 50 Duffinian numbers:');
  WriteLn;
  cur := 0;
  FOR seen := 1 TO 50 DO
  Begin
    REPEAT
      INC(cur)
    UNTIL IsDuffinian(cur);
    Write(cur:4);
    IF seen MOD 10 = 0 THEN
      WriteLn;
  END;

  WriteLn;
  WriteLn('First 15 Duffinian triples:');
  WriteLn;
  cur := 0;
  FOR seen := 1 TO 15 DO
  BEGIN
    REPEAT
      INC(cur)
    UNTIL IsDuffinianTriple(cur);
    Write(cur:6);
    Write(cur+1:6);
    Write(cur+2:6);
    WriteLn;
  END
END.// DuffinianNumbers.
