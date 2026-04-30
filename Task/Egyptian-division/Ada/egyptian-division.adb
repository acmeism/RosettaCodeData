with Ada.Text_IO;

procedure Egyptian_Division is

  procedure Divide  (a : Natural; b : Positive; q, r : out Natural) is
    doublings : array (0..31) of Natural;  -- The natural type holds values < 2^32 so no need going beyond
    m, sum, last_index_touched : Natural := 0;
  begin
    for i in doublings'Range loop
      m := b * 2**i;
      exit when m > a ;
      doublings (i) := m;
      last_index_touched := i;
    end loop;
    q := 0;
    for i in reverse doublings'First .. last_index_touched loop
        m := sum + doublings (i);
        if m <= a then
          sum := m;
          q := q + 2**i;
        end if;
    end loop;
    r := a -sum;
  end Divide;

  q, r : Natural;
begin
  Divide (580,34, q, r);
  Ada.Text_IO.put_line ("Quotient="&q'Img & " Remainder="&r'img);
end Egyptian_Division;
