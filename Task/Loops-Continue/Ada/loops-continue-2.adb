with Ada.Text_IO;
use Ada.Text_IO;

procedure Loop_Continue is
begin
        Print_All:
        for I in 1 .. 10 loop
                Print_Element: loop
                        Put (Integer'Image(I));
                        if I = 5 or I = 10 then
                                New_Line;
                                exit Print_Element;
                        end if;
                        Put (",");
                exit Print_Element;
                end loop Print_Element;
        end loop Print_All;
end Loop_Continue;
