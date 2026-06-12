with Ada.Text_IO;  use Ada.Text_IO;

procedure Szymanski_Algorithm is

   protected Room is
      function Get_Count return Natural; -- Tasks in the room
      entry Seize;                       -- Seize resource
      procedure Release;                 -- Release resoruce
   private
      Open  : Boolean := True;
      Owned : Boolean := False;
      Count : Natural := 0;
      entry Enter;
      entry Lock;
   end Room;

   protected body Room is
      function Get_Count return Natural is
      begin
         return Count;
      end Get_Count;

      procedure Release is
      begin
         Open  := Count = 0;
         Owned := False;
      end Release;

      entry Seize when True is
      begin
         requeue Enter;
      end Seize;

      entry Enter when Open is
      begin
         Open  := Seize'Count + Enter'Count /= 0;
         Count := Count + 1;
         requeue Lock;
      end Enter;

      entry Lock when not Open and not Owned is
      begin
         Count := Count - 1;
         Owned := True;
      end Lock;
   end Room;

   task type Setter (Value : Integer);
   task body Setter is
   begin
      for I in 1..10 loop
         Room.Seize;
         Put (Integer'Image (Value) & " is owning the resource");
         Put (Integer'Image (Room.Get_Count) & " tasks in the room...");
         delay 0.001;
         Put ("done");
         New_Line;
         Room.Release;
      end loop;
   end Setter;

   A : Setter (1);
   B : Setter (2);
   C : Setter (3);
   D : Setter (4);
   E : Setter (5);
   F : Setter (6);
begin
   null;
end Szymanski_Algorithm;
