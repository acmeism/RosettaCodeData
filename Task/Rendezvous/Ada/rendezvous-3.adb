with Ada.Text_IO;  use Ada.Text_IO;

procedure Rendezvous is
   Out_Of_Ink : exception;

   type Printer;
   type Printer_Ptr is access all Printer;
   task type Printer (ID : Natural; Backup : Printer_Ptr) is
      entry Print (Line : String);
   end Printer;

   task body Printer is
      Ink : Natural := 5;
   begin
      loop
         begin
            select
               accept Print (Line : String) do
                  if Ink = 0 then
                     if Backup = null then
                        raise Out_Of_Ink;
                     else
                        requeue Backup.Print with abort;
                     end if;
                  else
                     Put (Integer'Image (ID) & ": ");
                     for I in Line'Range loop
                        Put (Line (I));
                     end loop;
                     New_Line;
                     Ink := Ink - 1;
                  end if;
               end Print;
            or terminate;
            end select;
         exception
            when Out_Of_Ink =>
               null;
         end;
      end loop;
   end Printer;

   Reserve : aliased Printer (2, null);
   Main    : Printer (1, Reserve'Access);

   task Humpty_Dumpty;
   task Mother_Goose;

   task body Humpty_Dumpty is
   begin
      Main.Print ("Humpty Dumpty sat on a wall.");
      Main.Print ("Humpty Dumpty had a great fall.");
      Main.Print ("All the king's horses and all the king's men");
      Main.Print ("Couldn't put Humpty together again.");
   exception
      when Out_Of_Ink =>
         Put_Line ("      Humpty Dumpty out of ink!");
   end Humpty_Dumpty;

   task body Mother_Goose is
   begin
      Main.Print ("Old Mother Goose");
      Main.Print ("When she wanted to wander,");
      Main.Print ("Would ride through the air");
      Main.Print ("On a very fine gander.");
      Main.Print ("Jack's mother came in,");
      Main.Print ("And caught the goose soon,");
      Main.Print ("And mounting its back,");
      Main.Print ("Flew up to the moon.");
   exception
      when Out_Of_Ink =>
         Put_Line ("      Mother Goose out of ink!");
   end Mother_Goose;

begin
   null;
end Rendezvous;
