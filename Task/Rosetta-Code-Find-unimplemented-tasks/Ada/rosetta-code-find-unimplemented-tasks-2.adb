with Ada.Command_Line;               use Ada.Command_Line;
with Ada.Exceptions;                 use Ada.Exceptions;
with Ada.Text_IO;                    use Ada.Text_IO;
with Ada.Strings.Unbounded;          use Ada.Strings.Unbounded;
with GNUTLS;                         use GNUTLS;

with GNAT.Sockets.Server.Handles;    use GNAT.Sockets.Server.Handles;
with GNAT.Sockets.Server.Secure;     use GNAT.Sockets.Server.Secure;
with Strings_Edit.Streams;           use Strings_Edit.Streams;
with Parsers.JSON;                   use Parsers.JSON;
with Parsers.JSON.Multiline_Source;  use Parsers.JSON.Multiline_Source;

with GNAT.Sockets.Connection_State_Machine.HTTP_Client.Signaled;
with GNAT.Sockets.Connection_State_Machine.HTTP_Server;

with GNAT.Sockets.Server.Secure.X509;
use  GNAT.Sockets.Server.Secure.X509;

with Parsers.Multiline_Source.Stream_IO;
use  Parsers.Multiline_Source.Stream_IO;

with Stack_Storage;
with Generic_Indefinite_Set;

procedure Not_Coded is
   use GNAT.Sockets.Connection_State_Machine.HTTP_Client.Signaled;

   Address : constant String := "rosettacode.org";
   Path    : constant String := "w/api.php?action=query&"  &
                                "list=categorymembers&"    &
                                "format=json&cmlimit=500&" &
                                "cmtitle=Category:";
   Port    : constant := 443;
   Arena   : aliased Stack_Storage.Pool (2000, 512);

   package String_Sets is new Generic_Indefinite_Set (String);
   use type String_Sets.Set;
begin
   if Argument_Count /= 1 then
      Put_Line ("No language given!");
      Set_Exit_Status (Failure);
      return;
   end if;
   Put_Line ("GNUTLS: " & Check_Version);
   declare
      Factory   : aliased X509_Authentication_Factory
                          (Decoded_Size => 80);
      Message   : aliased String_Stream (1024 * 100);
      Server    : aliased GNAT.Sockets.Server.
                          Connections_Server (Factory'Access, 0);
      Reference : constant GNAT.Sockets.Server.Handles.Handle :=
                  Ref
                  (  new HTTP_Session_Signaled
                     (  Server'Unchecked_Access,
                        1024 * 10,
                        512,
                        1024
                  )  );
      Client    : HTTP_Session_Signaled renames
                  HTTP_Session_Signaled (Reference.Ptr.all);

      function Get (Category : String) return String_Sets.Set is
         Result   : String_Sets.Set;
         Continue : Unbounded_String;
      begin
         loop
            Message.Rewind; -- Overwrite from the beginning
            Client.Get
            (  "https://" & Address & "/" & Path & Category &
               To_String (Continue),
               Message'Unchecked_Access
            );
            Client.Wait (False);
            Message.Rewind;       -- Go to the start
            Arena.Deallocate_All; -- Clear arena for new JSON content
            declare
               Payload : aliased Source (Message'Access);
               Data    : constant JSON_Value :=
                         Parse (Payload'Access, Arena'Access);
               Members : constant JSON_Value :=
                         Data.Map / "query" / "categorymembers";
            begin
               for Item in Members.Sequence'Range loop
                  Result.Add (Members.Sequence (Item) / "title");
               end loop;
               Set_Unbounded_String
               (  Continue,
                  (  "&cmcontinue=" &
                     Data.Map / "continue" / "cmcontinue"
               )  );
            exception
               when End_Error =>
                  return Result;
            end;
         end loop;
      end Get;
   begin
      Client.Set_Keep_Alive (True);
      Client.Connect (Address, Port, 1);
      Client.Set_Request_Header -- Fool the obtruse server
      (  GNAT.Sockets.Connection_State_Machine.
         HTTP_Server.User_Agent_Header,
         "Mozilla/5.0 (Windows NT 10.0; Win64; x64; " &
         "rv:106.0) Gecko/20100101 Firefox/106.0"
      );
      declare
         S : constant String_Sets.Set :=
                      Get ("Programming_Tasks") - Get ("Ada");
      begin
         for I in 1..S.Get_Size loop
            Put_Line (S.Get (I));
         end loop;
      end;
   end;
   Set_Exit_Status (Success);
exception
   when Error : others =>
      Put_Line ("Error: " & Exception_Information (Error));
      Set_Exit_Status (Failure);
end Not_Coded;
