with Messages; use Messages;
with Ada.Streams.Stream_Io; use Ada.Streams.Stream_Io;
with Ada.Calendar; use Ada.Calendar;
with Ada.Text_Io;

procedure Streams_Example is
   S1 : Sensor_Message;
   M1 : Message;
   C1 : Control_Message;
   Now : Time := Clock;
   The_File : Ada.Streams.Stream_Io.File_Type;
   The_Stream : Ada.Streams.Stream_IO.Stream_Access;
begin
   S1 := (Now, 1234, 0.025);
   M1.Timestamp := Now;
   C1 := (Now, 15, 0.334);
   Display(S1);
   Display(M1);
   Display(C1);
   begin
      Open(File => The_File, Mode => Out_File,
         Name => "Messages.dat");
   exception
      when others =>
         Create(File => The_File, Name => "Messages.dat");
   end;
   The_Stream := Stream(The_File);
   Sensor_Message'Class'Output(The_Stream, S1);
   Message'Class'Output(The_Stream, M1);
   Control_Message'Class'Output(The_Stream, C1);
   Close(The_File);
   Open(File => The_File, Mode => In_File,
      Name => "Messages.dat");
   The_Stream := Stream(The_File);
   Ada.Text_Io.New_Line(2);
   while not End_Of_File(The_File) loop
      Display(Message'Class'Input(The_Stream));
   end loop;
   Close(The_File);
end Streams_Example;
