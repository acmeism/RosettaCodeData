with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

procedure powerset is
  procedure print_subset (set : natural) is
-- each i'th binary digit of "set" indicates if the i'th integer belongs to "set" or not.
    k : natural := set;
    first : boolean := true;
  begin
    Put ("{");
    for i in 1..Argument_Count loop
      if k mod 2 = 1 then
        if first then
          first := false;
        else
          Put (",");
        end if;
        Put (Argument (i));
      end if;
      k := k / 2; -- we go to the next bit of "set"
    end loop;
    Put_Line("}");
  end print_subset;
begin
  for i in 0..2**Argument_Count-1 loop
      print_subset (i);
  end loop;
end powerset;
