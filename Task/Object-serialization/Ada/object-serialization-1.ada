with Ada.Calendar; use Ada.Calendar;

package Messages is
   type Message is tagged record
      Timestamp : Time;
   end record;

   procedure Print(Item : Message);
   procedure Display(Item : Message'Class);

   type Sensor_Message is new Message with record
      Sensor_Id : Integer;
      Reading : Float;
   end record;

   procedure Print(Item : Sensor_Message);

   type Control_Message is new Message with record
      Actuator_Id : Integer;
      Command     : Float;
   end record;

   procedure Print(Item : Control_Message);

end Messages;
