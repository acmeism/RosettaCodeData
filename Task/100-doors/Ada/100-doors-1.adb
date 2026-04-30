with Ada.Text_Io; use Ada.Text_Io;

 procedure Doors is
    type Door_State is (Closed, Open);
    type Door_List is array(Positive range 1..100) of Door_State;
    The_Doors : Door_List := (others => Closed);
 begin
    for I in 1..100 loop
       for J in The_Doors'range loop
          if J mod I = 0 then
             if The_Doors(J) = Closed then
                 The_Doors(J) := Open;
             else
                The_Doors(J) := Closed;
             end if;
          end if;
       end loop;
    end loop;
    for I in The_Doors'range loop
       Put_Line(Integer'Image(I) & " is " & Door_State'Image(The_Doors(I)));
    end loop;
 end Doors;
