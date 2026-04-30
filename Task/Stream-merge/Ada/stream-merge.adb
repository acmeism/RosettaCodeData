with Ada.Text_Io;
with Ada.Command_Line;
with Ada.Containers.Indefinite_Holders;

procedure Stream_Merge is

   package String_Holders
   is new Ada.Containers.Indefinite_Holders (String);

   use Ada.Text_Io, String_Holders;

   type Stream_Type is
      record
         File  : File_Type;
         Value : Holder;
      end record;

   subtype Index_Type is Positive range 1 .. Ada.Command_Line.Argument_Count;
   Streams : array (Index_Type) of Stream_Type;

   procedure Fetch (Stream : in out Stream_Type) is
   begin
      Stream.Value := (if End_Of_File (Stream.File)
                       then Empty_Holder
                       else To_Holder (Get_Line (Stream.File)));
   end Fetch;

   function Next_Stream return Index_Type is
      Index : Index_Type := Index_Type'First;
      Value : Holder;
   begin
      for I in Streams'Range loop
         if Value.Is_Empty and not Streams (I).Value.Is_Empty then
            Value := Streams (I).Value;
            Index := I;
         elsif not Streams (I).Value.Is_Empty and then Streams (I).Value.Element < Value.Element then
            Value := Streams (I).Value;
            Index := I;
         end if;
      end loop;
      if Value.Is_Empty then
         raise Program_Error;
      end if;
      return Index;
   end Next_Stream;

   function More_Data return Boolean
   is (for some Stream of Streams => not Stream.Value.Is_Empty);

begin

   if Ada.Command_Line.Argument_Count = 0 then
      Put_Line ("Usage: prog <file1> <file2> ...");
      Put_Line ("Merge the sorted files file1, file2...");
      return;
   end if;

   for I in Streams'Range loop
      Open (Streams (I).File, In_File, Ada.Command_Line.Argument (I));
      Fetch (Streams (I));
   end loop;

   while More_Data loop
      declare
         Stream : Stream_Type renames Streams (Next_Stream);
      begin
         Put_Line (Stream.Value.Element);
         Fetch (Stream);
      end;
   end loop;

end Stream_Merge;
