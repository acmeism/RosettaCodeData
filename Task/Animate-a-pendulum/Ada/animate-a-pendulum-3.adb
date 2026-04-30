with Ada.Text_IO;
with Ada.Calendar;
with Pendulums;

procedure Main is
   package Float_Pendulum is new Pendulums (Float, -9.81);
   use Float_Pendulum;
   use type Ada.Calendar.Time;

   My_Pendulum : Pendulum := New_Pendulum (10.0, 30.0);
   Now, Before : Ada.Calendar.Time;
begin
   Before := Ada.Calendar.Clock;
   loop
      Delay 0.1;
      Now := Ada.Calendar.Clock;
      Update_Pendulum (My_Pendulum, Now - Before);
      Before := Now;
      -- output positions relative to origin
      -- replace with graphical output if wanted
      Ada.Text_IO.Put_Line (" X: " & Float'Image (Get_X (My_Pendulum)) &
                            " Y: " & Float'Image (Get_Y (My_Pendulum)));
   end loop;
end Main;
