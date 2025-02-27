function doubleDigit(n: integer) := (n * 2).ToString.Select(c -> c.ToDigit).Sum;

function LuhnCheck(creditCardNumber: string): boolean;
begin
  var checkSum := creditCardNumber
            .Select(c -> c.ToDigit)
            .Reverse
            .Select((digit, index) -> (if odd(index + 1) then digit else doubleDigit(digit)))
            .Sum;

  result := checkSum mod 10 = 0;
end;

begin
  var testNumbers := |49927398716, 49927398717, 1234567812345678, 1234567812345670|;
  foreach var testNumber in testNumbers do
    Writeln(testnumber, ' is ', if LuhnCheck(testNumber.ToString) then '' else 'not ', 'valid');
end.
