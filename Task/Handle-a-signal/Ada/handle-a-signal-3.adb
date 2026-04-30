with Ada.Calendar; use Ada.Calendar;
with Ada.Text_Io; use Ada.Text_Io;
with Sigint_Handler; use Sigint_Handler;

procedure Signals is
   task Counter is
      entry Stop;
   end Counter;
   task body Counter is
      Current_Count : Natural := 0;
   begin
      loop
         select
            accept Stop;
            exit;
         or delay 0.5;
         end select;
         Current_Count := Current_Count + 1;
         Put_Line(Natural'Image(Current_Count));
      end loop;
   end Counter;
   task Sig_Handler;

   task body Sig_Handler is
      Start_Time : Time := Clock;
      Sig_Time : Time;
   begin
      Handler.Wait;
      Sig_Time := Clock;
      Counter.Stop;
      Put_Line("Program execution took" & Duration'Image(Sig_Time - Start_Time) & " seconds");
   end Sig_Handler;

begin
   null;

end Signals;
