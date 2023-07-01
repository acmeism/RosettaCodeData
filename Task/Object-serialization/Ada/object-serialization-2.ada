with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body Messages is

   -----------
   -- Print --
   -----------

   procedure Print (Item : Message) is
      The_Year : Year_Number;
      The_Month : Month_Number;
      The_Day   : Day_Number;
      Seconds   : Day_Duration;
   begin
      Split(Date => Item.Timestamp, Year => The_Year,
         Month => The_Month, Day => The_Day, Seconds => Seconds);

      Put("Time Stamp:");
      Put(Item => The_Year, Width => 4);
      Put("-");
      Put(Item => The_Month, Width => 1);
      Put("-");
      Put(Item => The_Day, Width => 1);
      New_Line;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (Item : Sensor_Message) is
   begin
      Print(Message(Item));
      Put("Sensor Id: ");
      Put(Item => Item.Sensor_Id, Width => 1);
      New_Line;
      Put("Reading: ");
      Put(Item => Item.Reading, Fore => 1, Aft => 4, Exp => 0);
      New_Line;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (Item : Control_Message) is
   begin
      Print(Message(Item));
      Put("Actuator Id: ");
      Put(Item => Item.Actuator_Id, Width => 1);
      New_Line;
      Put("Command: ");
      Put(Item => Item.Command, Fore => 1, Aft => 4, Exp => 0);
      New_Line;
   end Print;

   -------------
   ---Display --
   -------------

   procedure Display(Item : Message'Class) is
   begin
      Print(Item);
   end Display;

end Messages;
