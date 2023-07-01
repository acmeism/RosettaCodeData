program manorboy(output);

function zero: integer; begin zero := 0 end;
function one: integer; begin one := 1 end;
function negone: integer; begin negone := -1 end;

function A(
  k: integer;
  function x1: integer;
  function x2: integer;
  function x3: integer;
  function x4: integer;
  function x5: integer
): integer;

  function B: integer;
  begin k := k - 1;
        B := A(k, B, x1, x2, x3, x4)
  end;

begin if k <= 0 then A := x4 + x5 else A := B
end;

begin writeln(A(10, one, negone, negone, one, zero))
end.
