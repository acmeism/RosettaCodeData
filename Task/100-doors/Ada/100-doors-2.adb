with Ada.Text_Io; use Ada.Text_Io;
 with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

 procedure Doors_Optimized is
    Num : Float;
 begin
    for I in 1..100 loop
       Num := Sqrt(Float(I));
       Put(Integer'Image(I) & " is ");
       if Float'Floor(Num) = Num then
          Put_Line("Opened");
       else
          Put_Line("Closed");
       end if;
    end loop;
 end Doors_Optimized;
