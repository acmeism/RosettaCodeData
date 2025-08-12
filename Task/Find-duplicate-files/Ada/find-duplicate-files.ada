with Ada.Command_Line;
with Ada.Containers;
with Ada.Containers.Ordered_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Directories;
with Ada.Streams.Stream_IO;
with Ada.Text_IO;

with GNAT.MD5;

procedure Find_Duplicates is

   Root_Dir : constant String := Ada.Command_Line.Argument (1);
   Size_Limit : constant Ada.Directories.File_Size :=
     Ada.Directories.File_Size'Value (Ada.Command_Line.Argument (2));
   Pattern : constant String := "*";
   Filter : constant Ada.Directories.Filter_Type :=
     (
      Ada.Directories.Directory => True,
      Ada.Directories.Ordinary_File => True,
      others => False
     );

   type File_Data is
      record
         Hash : GNAT.MD5.Message_Digest;
         Size : Ada.Directories.File_Size;
      end record;

   type File_Name is new String;

   function File_Order (Left, Right : File_Data) return Boolean is
     (Ada.Directories."<" (Right.Size, Left.Size));

   package Dir_Vectors is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Positive, Element_Type => File_Name);
   package Dir_Maps is new Ada.Containers.Ordered_Maps
     (Key_Type => File_Data, Element_Type => Dir_Vectors.Vector,
      "<" => File_Order, "=" => Dir_Vectors."=");

   function File_Hash (Name : String) return GNAT.MD5.Message_Digest is
      File : Ada.Streams.Stream_IO.File_Type;
      Context : GNAT.MD5.Context := GNAT.MD5.Initial_Context;
      Items : Ada.Streams.Stream_Element_Array
        (1 .. 4096);
      Last : Ada.Streams.Stream_Element_Offset := 0;
   begin
      Ada.Streams.Stream_IO.Open (File, Ada.Streams.Stream_IO.In_File, Name);

      while not Ada.Streams.Stream_IO.End_Of_File (File) loop
         Ada.Streams.Stream_IO.Read (File, Items, Last);

         if Ada.Streams."<" (Last, Items'Last) then
            GNAT.MD5.Update (Context, Items (Items'First .. Last));
         else
            GNAT.MD5.Update (Context, Items);
         end if;
      end loop;

      return GNAT.MD5.Digest (Context);
   end;

   Dir_Map : Dir_Maps.Map := Dir_Maps.Empty_Map;

   procedure Insert (Name : String) is
      Hash : constant GNAT.MD5.Message_Digest := File_Hash (Name);
      Size : constant Ada.Directories.File_Size := Ada.Directories.Size (Name);
      Data : constant File_Data := (Hash, Size);
      Pos : Dir_Maps.Cursor;
      Ins : Boolean;
      procedure Append_Name (K : File_Data; V : in out Dir_Vectors.Vector) is
      begin
         V.Append (File_Name (Name));
      end Append_Name;
   begin
      Dir_Map.Insert (Data, Dir_Vectors.Empty_Vector, Pos, Ins);
      --  We can update whether we inserted a new element or not.
      Dir_Map.Update_Element (Pos, Append_Name'Access);
   end Insert;

   procedure Walk (Dir_Ent : Ada.Directories.Directory_Entry_Type) is
      Name : constant String := Ada.Directories.Full_Name (Dir_Ent);
      SName : constant String := Ada.Directories.Simple_Name (Dir_Ent);
      Size : Ada.Directories.File_Size;
   begin
      if SName = "." or else SName = ".." then
         return;
      end if;

      case Ada.Directories.Kind (Dir_Ent) is
         when Ada.Directories.Ordinary_File =>
            Size := Ada.Directories.Size (Name);
            if Ada.Directories.">=" (Size, Size_Limit) then
               Insert (Name);
            end if;
         when Ada.Directories.Directory =>
            Ada.Directories.Search
              (Name, Pattern, Filter, Walk'Access);
         when others => raise Constraint_Error;
      end case;
   end Walk;

   procedure Show_Duplicates is
      Count : Ada.Containers.Count_Type;
      K : File_Data;
      Dv : Dir_Vectors.Vector;
   begin
      for Pos in Dir_Map.Iterate loop
         Dv := Dir_Map.Constant_Reference (Pos);
         Count := Dv.Length;

         if Ada.Containers.">"(Count, 1) then
            K := Dir_Maps.Key (Pos);
            Ada.Text_IO.Put_Line
              ("Found " & Count'Image & " files matching Size => "
               & K.Size'Image & ", MD5 => " & K.Hash);

            for E of Dv loop
               Ada.Text_IO.Put_Line (String (E));
            end loop;
         end if;
      end loop;
   end Show_Duplicates;
begin
   Ada.Directories.Search
     (Root_Dir, Pattern, Filter, Walk'Access);
   Show_Duplicates;
end Find_Duplicates;
