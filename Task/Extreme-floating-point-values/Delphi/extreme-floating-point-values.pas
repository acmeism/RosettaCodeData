program Floats;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  PlusInf, MinusInf, NegZero, NotANum: Double;

begin
  PlusInf:= 1.0/0.0;
  MinusInf:= -1.0/0.0;
  NegZero:= -1.0/PlusInf;
  NotANum:= 0.0/0.0;

  Writeln('Positive Infinity: ', PlusInf);      // +Inf
  Writeln('Negative Infinity: ', MinusInf);     // -Inf
  Writeln('Negative Zero: ', NegZero);          // -0.0
  Writeln('Not a Number: ', NotANum);           // Nan

// allowed arithmetic
  Writeln('+Inf + 2.0 = ', PlusInf + 2.0);      // +Inf
  Writeln('+Inf - 10.1 = ', PlusInf - 10.1);    // +Inf
  Writeln('NaN + 1.0 = ', NotANum + 1.0);       // Nan
  Writeln('NaN + NaN = ', NotANum + NotANum);   // Nan

// throws exception
  try
    Writeln('+inf + -inf = ', PlusInf + MinusInf);  // EInvalidOp
    Writeln('0.0 * +inf = ', 0.0 * PlusInf);        // EInlalidOp
    Writeln('1.0/-0.0 = ', 1.0 / NegZero);          // EZeroDivide
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

  Readln;
end.
