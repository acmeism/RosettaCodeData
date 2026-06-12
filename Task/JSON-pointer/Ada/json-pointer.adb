with Ada.Text_IO;                 use Ada.Text_IO;
with Parsers.JSON;                use Parsers.JSON;
with Parsers.JSON.String_Source;  use Parsers.JSON.String_Source;
with Parsers.String_Source;       use Parsers.String_Source;
with Stack_Storage;

procedure JSON_Pointer is
   Text : aliased String :=
          "{"                                                        &
           """wiki"": {"                                             &
            """links"": ["                                           &
              """https://rosettacode.org/wiki/Rosetta_Code"","       &
              """https://discord.com/channels/1011262808001880065""" &
             "]"                                                     &
           "},"                                                      &
           """"": ""Rosetta"","                                      &
           """ "": ""Code"","                                        &
           """g/h"": ""chrestomathy"","                              &
           """i~j"": ""site"","                                      &
           """abc"": [""is"", ""a""],"                               &
           """def"": { """": ""programming"" }"                      &
          "}";
   Arena : aliased Stack_Storage.Pool (200, 512);
   Input : aliased Source (Text'Access);
   Data  : constant JSON_Value := Parse (Input'Access, Arena'Access);
begin
   Put_Line (Image (Data));
   Put_Line (Data / "");
   Put_Line (Data / " ");
   Put_Line (Data / "i~j");
   Put_Line (Image (JSON_Value'(Data / "abc")));
   Put_Line (Data / "def" / "");
   Put_Line (Data / "wiki" / "links" / 1); -- In Ada we use 1-based arrays
   Put_Line (Data / "wiki" / "links" / 2);
   begin
      Put_Line (Data / "wiki" / "links" / 3);
   exception
      when Constraint_Error =>
         Put_Line ("invalid path");
   end;
end JSON_Pointer;
