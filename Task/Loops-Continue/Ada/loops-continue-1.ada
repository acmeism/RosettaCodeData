with Ada.Text_IO;
use Ada.Text_IO;

procedure Loop_Continue is
begin
        for I in 1..10 loop
                Put (Integer'Image(I));
                if I = 5 or I = 10 then
                        New_Line;
                        goto Continue;
                end if;
                Put (",");
                <<Continue>>  --Ada 2012 no longer requires a statement after the label
        end loop;
end Loop_Continue;
