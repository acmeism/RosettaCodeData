with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
use Ada.Strings;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Main is
   function extension (S : in String) return String is
      P_Index : Natural;
   begin
      P_Index :=
        Index (Source => S, Pattern => ".", From => S'Last, Going => Backward);
      if P_Index < 2 or else P_Index = S'Last then
         return "";
      else
         for C of S (P_Index + 1 .. S'Last) loop
            if not Is_Alphanumeric (C) then
               return "";
            end if;
         end loop;
         return S (P_Index .. S'Last);
      end if;
   end extension;
   F1 : String := "http://example.com/download.tar.gz";
   F2 : String := "CharacterModel.3DS";
   F3 : String := ".desktop";
   F4 : String := "document";
   F5 : String := "document.txt_backup";
   F6 : String := "/etc/pam.d/login:";
   F7 : String := "filename.";
   F8 : String := ".";
begin
   Put_Line (F1 & " -> " & extension (F1));
   Put_Line (F2 & " -> " & extension (F2));
   Put_Line (F3 & " -> " & extension (F3));
   Put_Line (F4 & " -> " & extension (F4));
   Put_Line (F5 & " -> " & extension (F5));
   Put_Line (F6 & " -> " & extension (F6));
   Put_Line (F7 & " -> " & extension (F7));
   Put_Line (F8 & " -> " & extension (F8));
end Main;
