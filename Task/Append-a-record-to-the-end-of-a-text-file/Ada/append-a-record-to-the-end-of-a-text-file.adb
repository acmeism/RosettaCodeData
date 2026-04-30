with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Bounded;

procedure Main is
   package data_string is new Ada.Strings.Bounded.Generic_Bounded_Length(80);
   use data_string;

   type GCOSE_Rec is record
      Full_Name : Bounded_String;
      Office    : Bounded_String;
      Extension : Bounded_String;
      Homephone : Bounded_String;
      Email     : Bounded_String;
   end record;

   type Password_Rec is record
      Account   : Bounded_String;
      Password  : Bounded_String;
      Uid       : Natural;
      Gid       : Natural;
      GCOSE     : GCOSE_Rec;
      Directory : Bounded_String;
      Shell     : Bounded_String;
   end record;

   function To_String(Item : GCOSE_Rec) return String is
   begin
      return To_String(Item.Full_Name) & "," &
        To_String(Item.Office) & "," &
        To_String(Item.Extension) & "," &
        To_String(Item.Homephone) & "," &
        To_String(Item.Email);
   end To_String;

   function To_String(Item : Password_Rec) return String is
      uid_str : string(1..4);
      gid_str : string(1..4);
      Temp : String(1..5);
   begin
      Temp := Item.Uid'Image;
      uid_str := Temp(2..5);
      Temp := Item.Gid'Image;
      gid_str := Temp(2..5);
      return To_String(Item.Account) & ":" &
        To_String(Item.Password) & ":" &
        uid_str & ":" & gid_str & ":" &
        To_String(Item.GCOSE) & ":" &
        To_String(Item.Directory) & ":" &
        To_String(Item.Shell);
   end To_String;

   Pwd_List : array (1..3) of Password_Rec;

   Filename : String := "password.txt";
   The_File : File_Type;
   Line : String(1..256);
   Length : Natural;
begin
   Pwd_List(1) := (Account => To_Bounded_String("jsmith"),
                   Password => To_Bounded_String("x"),
                   Uid => 1001, GID => 1000,
                   GCOSE => (Full_Name => To_Bounded_String("Joe Smith"),
                             Office => To_Bounded_String("Room 1007"),
                             Extension => To_Bounded_String("(234)555-8917"),
                             Homephone => To_Bounded_String("(234)555-0077"),
                             email => To_Bounded_String("jsmith@rosettacode.org")),
                   directory => To_Bounded_String("/home/jsmith"),
                   shell => To_Bounded_String("/bin/bash"));
   Pwd_List(2) := (Account => To_Bounded_String("jdoe"),
                   Password => To_Bounded_String("x"),
                   Uid => 1002, GID => 1000,
                   GCOSE => (Full_Name => To_Bounded_String("Jane Doe"),
                             Office => To_Bounded_String("Room 1004"),
                             Extension => To_Bounded_String("(234)555-8914"),
                             Homephone => To_Bounded_String("(234)555-0044"),
                             email => To_Bounded_String("jdoe@rosettacode.org")),
                   directory => To_Bounded_String("/home/jdoe"),
                   shell => To_Bounded_String("/bin/bash"));
   Pwd_List(3) := (Account => To_Bounded_String("xyz"),
                   Password => To_Bounded_String("x"),
                   Uid => 1003, GID => 1000,
                   GCOSE => (Full_Name => To_Bounded_String("X Yz"),
                             Office => To_Bounded_String("Room 1003"),
                             Extension => To_Bounded_String("(234)555-8913"),
                             Homephone => To_Bounded_String("(234)555-0033"),
                             email => To_Bounded_String("xyz@rosettacode.org")),
                   directory => To_Bounded_String("/home/xyz"),
                   shell => To_Bounded_String("/bin/bash"));
   Create(File => The_File,
          Mode => Out_File,
          Name => Filename);

   for I in 1..2 loop
      Put_Line(File => The_File,
               Item => To_String(Pwd_List(I)));
   end loop;
   Reset(File => The_File,
         Mode => In_File);
   while not End_Of_File(The_File) loop
      Get_Line(File => The_File,
               Item => Line,
               Last => Length);
      Put_Line(Line(1..Length));
   end loop;
   New_Line;
   Reset(File => The_File,
         Mode => Append_File);
   Put_Line(File => The_File,
            Item => To_String(Pwd_List(3)));
   Reset(File => The_File,
         Mode => In_File);
   while not End_Of_File(The_File) loop
      Get_Line(File => The_File,
               Item => Line,
               Last => Length);
      Put_Line(Line(1..Length));
   end loop;
   Close(The_File);
end Main;
