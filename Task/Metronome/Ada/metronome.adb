with Ada.Text_IO;   use Ada.Text_IO;

 --This package is for the delay.
with Ada.Calendar;  use Ada.Calendar;

 --This package adds sound
with Ada.Characters.Latin_1;

procedure Main is

begin

   Put_Line ("Hello, this is 60 BPM");

   loop

      Ada.Text_IO.Put (Ada.Characters.Latin_1.BEL);
      delay 0.9; --Delay in seconds.  If you change to 0.0 the program will crash.

   end loop;

end Main;
