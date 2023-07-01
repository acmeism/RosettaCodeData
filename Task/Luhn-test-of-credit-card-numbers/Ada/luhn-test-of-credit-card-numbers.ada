with Ada.Text_IO;
use  Ada.Text_IO;

procedure Luhn is

  function Luhn_Test (Number: String) return Boolean is
    Sum  : Natural := 0;
    Odd  : Boolean := True;
    Digit: Natural range 0 .. 9;
  begin
    for p in reverse Number'Range loop
      Digit := Integer'Value (Number (p..p));
      if Odd then
        Sum := Sum + Digit;
      else
        Sum := Sum + (Digit*2 mod 10) + (Digit / 5);
      end if;
      Odd := not Odd;
    end loop;
    return (Sum mod 10) = 0;
  end Luhn_Test;

begin

  Put_Line (Boolean'Image (Luhn_Test ("49927398716")));
  Put_Line (Boolean'Image (Luhn_Test ("49927398717")));
  Put_Line (Boolean'Image (Luhn_Test ("1234567812345678")));
  Put_Line (Boolean'Image (Luhn_Test ("1234567812345670")));

end Luhn;
