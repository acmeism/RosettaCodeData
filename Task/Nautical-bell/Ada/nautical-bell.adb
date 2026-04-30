with Ada.Calendar;             use Ada.Calendar;
with Ada.Calendar.Formatting;  use Ada.Calendar.Formatting;
with Ada.Text_IO;              use Ada.Text_IO;

procedure Nautical_Bell is
   task Ship_Bell;
   task body Ship_Bell is
      Stamp  : Time := Clock;

      procedure Bang is
      begin
         Put ("bang " & Character'Val (7));
      end Bang;
      procedure Bang_Bang is
      begin
         Put ("bang" & Character'Val (7));
         delay 2.0;
         Put ("-bang " & Character'Val (7));
         delay 2.0;
      end Bang_Bang;
   begin
      loop
         Stamp :=   -- The next half-hour
            Stamp - Sub_Second (Stamp) -
            Duration ((Minute (Stamp) mod 30 - 30) * 60 + Second (Stamp));
         delay until Stamp;
         Stamp := Clock;
         Put (Image (Stamp, True) & " ");
         case (Hour (Stamp) * 2 + Minute (Stamp) / 30) mod 8 is
            when 1      => Bang;
            when 2      => Bang_Bang;
            when 3      => Bang_Bang; Bang;
            when 4      => Bang_Bang; Bang_Bang;
            when 5      => Bang_Bang; Bang_Bang; Bang;
            when 6      => Bang_Bang; Bang_Bang; Bang_Bang;
            when 7      => Bang_Bang; Bang_Bang; Bang_Bang; Bang;
            when others => Bang_Bang; Bang_Bang; Bang_Bang; Bang_Bang;
         end case;
         New_Line;
      end loop;
   end Ship_Bell;
begin
   null; -- Go forever waiting for tasks to end
end Nautical_Bell;
